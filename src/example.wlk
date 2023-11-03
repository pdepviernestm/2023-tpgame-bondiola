
import wollok.game.*
import personajes.*
import Fondos.*
const corazon1= new Estatico(position=game.at(1,13))
const corazon2= new Estatico(position=game.at(2,13))
const corazon3= new Estatico(position=game.at(3,13))
const corazonNegro2 = new CorazonNegro(position=game.at(2,13))
const corazonNegro3 = new CorazonNegro(position=game.at(3,13))


object juego {
	const anchoTotal= 20
	const altoTotal = 14
	method iniciar(){
		game.clear()
		/*Aumenta la dimension de las celdas */
		game.cellSize(70)
		
		game.width(anchoTotal)			
		game.height(altoTotal)
		game.boardGround("img/grass_15.png") 
		game.addVisualCharacter(jorge)	
		game.addVisual(corazon1)
		game.addVisual(corazon2)
		game.addVisual(corazon3)
		game.addVisual(reloj)
		game.addVisual(contadorBalas)
		game.addVisual(balaEstatica)
		reloj.iniciar()
		contadorBalas.iniciar()
		game.onCollideDo(jorge , {algo => algo.teAgarroJorge()})
		
		 keyboard.up().onPressDo( {jorge.apuntar('Arriba')})
		 keyboard.right().onPressDo( {jorge.apuntar('Derecha')})
		 keyboard.left().onPressDo( {jorge.apuntar('Izq')})
		 keyboard.down().onPressDo( {jorge.apuntar('Abajo')})
		 keyboard.space().onPressDo({jorge.disparar()})
		
		
		self.generarZombies()
		self.generarPotenciadores()
		
	}
	
	method generarZombies(){
		game.onTick(2000 , "aparece zombie" , {new Zombies().aparecer()})
	}
	
	method generarPotenciadores(){
		game.schedule(5000  , {self.generarPotenciador("vida")})
		
		game.schedule(10000  , {self.generarPotenciador("municion")})
		
	}
	
	method generarPotenciador(tipo){
		const pos = self.posicionAleatoria()
		
		if(tipo == "vida"){
			const potenciadorVida = new Potenciadores(position=pos , tipo = tipo  , image = "img/pngegg.png")
			game.addVisual(potenciadorVida)
		}else{
			const potenciadorMunicion = new Potenciadores(position=pos , tipo = "municion" , image="img/bala.png")
			game.addVisual(potenciadorMunicion)
		}	
	}
	
	method posicionAleatoria()= game.at(
		0.randomUpTo(game.width()),
		0.randomUpTo(game.height())
	)
	
	method gameOver(){
		
        game.clear()
        juegoTerminado.sucede()
		game.addVisual(reloj)
		reloj.nuevaPosicion(9,4)
		
        keyboard.f().onPressDo{game.stop()}
       	keyboard.p().onPressDo{self.iniciar()}
   
	}
}
 
class Potenciadores{
	var position
	var image 
	var tipo=""
	var property perfil=null
	method teAgarroJorge(){
		//jorge.aumentar(tipo)
		game.removeVisual(self)
		game.schedule(5000 , {juego.generarPotenciador(tipo)} )
		
	}
	
	
	  /*HACE APARECER EL POTENCIADOR CADA 5 SEGUNDOS */
	method aparecer(){
		game.schedule(5000,{self.desaparecer()})
	}
	
	method desaparecer(){
		game.removeVisual(self)
	}
	
	method image()= image
	
	
	
	method position()= position
	
	method efectoBala(balaQueDio){}
}

class Estatico{
	var property position 
	method image() = "img/pngegg.png"
	method teAgarroJorge(){}
	method efectoBala(balaQueDio){}
}

class CorazonNegro inherits Estatico{
	override method image() = "img/corazonNegro.png"
}

object balaEstatica{
	method position() = game.at(9,13)
	method image() = "img/bala_arriba.png"
	method teAgarroJorge(){}
	method efectoBala(balaQueDio){}
}

class Corazon inherits Potenciadores{
	override method position() = position
	override method image() = "img/pngegg.png"
	
	override method teAgarroJorge(){
		super()
		jorge.aumentarVida()
	}
	
	method sacarCorazon(){
		game.removeVisual(self)
	}
	
	method agregarCorazon(){
		game.addVisual(self)
	}
	
	
}


class Bala inherits Potenciadores(perfil = "bala_izq" ) {
	
	override method position() =  position
	
	override method perfil()= perfil 
	
	override method image() = "img/" + self.perfil() +".png"
	
	
	
	method movDisparo(){
		game.onTick(100 , "moverse",{self.moverse()})
		game.onCollideDo(self , {algo => algo.efectoBala(self)})
	}
	
	override method teAgarroJorge(){
		super()
		jorge.aumentarMunicion()
	}
	
	method orientacionBala(){
		if (jorge.direccion() == "Arriba" ){
			self.perfil("bala_arriba")
			
			/*jorge.balas() == jorge.balas() - 1*/
			
			self.moverse()
		}
		else if (jorge.direccion() == "Abajo"){
			self.perfil("bala_abajo")
			
			self.moverse()
		}
		else if (jorge.direccion() == "Derecha" ){
			self.perfil("bala_der")
			
			
			self.moverse()
		}
		else if (jorge.direccion() == "Izq" ){
			self.perfil("bala_izq")
			self.moverse()
		}
	}
	
	
	
	method moverse(){
		if (perfil == "bala_arriba"){
			position = position.up(1)
		}
		else if (perfil == "bala_abajo"){
			position = position.down(1)
		}
		else if (perfil == "bala_der"){
			position = position.right(1)
		}
		else if (perfil == "bala_izq"){
			position = position.left(1)
		}
		
	}
	method disparoIni(){
		if (jorge.direccion() == "Arriba" && jorge.balas() != 0){
			self.perfil("funny_bala4")
			
			/*jorge.balas() == jorge.balas() - 1*/
			position = jorge.position().up(1)
			self.movDisparo()
		}
		else if (jorge.direccion() == "Abajo" && jorge.balas() != 0){
			self.perfil("funny_bala2")
			game.addVisual(self)
			jorge.balas() == jorge.balas() - 1
			position = jorge.position().down(1)
			self.movDisparo()
		}
		else if (jorge.direccion() == "Derecha" && jorge.balas() != 0){
			self.perfil("funny_bala3")
			game.addVisual(self)
			jorge.balas() == jorge.balas().right(1)
			position = jorge.position() + position.x(1)
			self.movDisparo()
		}
		else if (jorge.direccion() == "Izq" && jorge.balas() != 0){
			game.addVisual(self)
			jorge.balas() == jorge.balas().left(1)
			position = jorge.position() - position.x(1)
			self.movDisparo()
		}
		else{
			/*game.say(jorge,"No tengo balas")*/
		}
		
	
	
	
	
	}
	
	
	
}

object contadorBalas{
	
	var cantBalas = jorge.balas()
	
	method text() = cantBalas.toString()
	method textColor() = paleta.rojo()
	method position() = game.at(10,13)
	
	method actualizo(){
		cantBalas = jorge.balas()
	}
	method iniciar(){
        game.onTick(1,"revisa balas",{self.actualizo()})
        }
        method teAgarroJorge(){}
	method efectoBala(balaQueDio){}
   
}
