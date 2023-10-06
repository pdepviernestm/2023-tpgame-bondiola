
/*
 * HACER QUE LOS ZOMBIES CAMBIEN DE DIRECCION 
 * HACER QUE EL PERSONAJE DISPARE 
 * DARLE FUNCIONES A VIDA Y MUNICION
 * MOSTRAR MUNICION
 * 
 * */

import wollok.game.*
import direcciones.*

object juego {
	method iniciar(){
		
		game.width(50)
		game.height(35)
		game.addVisualCharacter(jorge)	
		
		game.onCollideDo(jorge , {algo => algo.teAgarroJorge()})
		
		 keyboard.up().onPressDo( {jorge.moverArriba()})
		 keyboard.right().onPressDo( {jorge.moverDerecha()})
		 keyboard.left().onPressDo( {jorge.moverIzquierda()})
		 keyboard.down().onPressDo( {jorge.moverAbajo()})
		 keyboard.space().onPressDo({jorge.disparar()})
		
		
		
		self.generarZombies()
		self.generarPotenciadores()
		/* A LOS 20 SEGUNDOS DESAPARECEN TODOS LOS ZOMBIES */
		//game.schedule(20000,{game.removeTickEvent("aparece zombie")})
	}
	
	method generarZombies(){
		game.onTick(1000 , "aparece zombie" , {new Zombies().aparecer()})
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
	
	
	/*img/personaje_Abajo.png */
	
}
 /*PROTAGONISTA */
object jorge {
	var property position = game.center()
	var vidas = 5
	var property balas = 10
	var property image = self.perfil()
	var property perfil = "personaje_Abajo"
	method image() = "img/" + self.perfil() +".png"
	//keyboard.enter().onPressDo({game.removeTickEvent("aparecer invasor")})
	

	method moverArriba(){
 		self.perfil("personaje_Arriba")				 
 }
 	
    method moverAbajo(){
 		self.perfil("personaje_Abajo")
 }
 	
 	method moverDerecha(){
 		
 		self.perfil("personaje_Derecha")
 	} 
 	
 	method moverIzquierda(){
 		
 		self.perfil("personaje_Izq")
 	}
	
	method aumentar(tipo){
		 if(tipo == "vida" ){
		 	vidas ++
		 	game.say(jorge,"Tengo" + jorge.vidas() + " vidas.")
		 }else{
		 	game.say(jorge,"Agarre municion")
		 }
	}
	
	
	
	method perderVida(){
		vidas -= 1
	}
	method vidas() = vidas
	
	method disparar(){
		new Bala().disparoIni()
	}
}   


/*ZOMBIES */
class Zombies {
	var property position = null
	var property image = self.perfil()
	var property perfil = "zombie_Abajo"
	method teAgarroJorge(){
		jorge.perderVida()
		game.say(jorge,"Me quedan " + jorge.vidas() + " vidas.")
		self.desaparecer()
	}
	
	method desaparecer(){
		if(game.hasVisual(self))
			game.removeVisual(self)
		game.removeTickEvent("acercarse")
	}
	
	method aparecer(){
		position = juego.posicionAleatoria()
		game.addVisual(self)
		self.perseguirAJorge()
		
	}
	
	
	
	method perseguirAJorge(){
		game.onTick(550 , "acercarse",{self.darUnPaso(jorge.position())})
	}
	
	method darUnPaso(destino){
		if ((position.x() + ((destino.x()-position.x())/6000).roundUp()) > position.x()){
			self.derecha()
		}
		else if ((position.x() + ((destino.x()-position.x())/6000).roundUp()) < position.x()){
			self.izquierda()
		}
		else if ((position.y() + ((destino.y()-position.y())/6000).roundUp()) > position.y()){
			self.arriba()
		}
		else if ((position.y() + ((destino.y()-position.y())/6000).roundUp()) < position.y()){
			self.abajo()
		}	
		position = game.at(
		position.x() + ((destino.x()-position.x())/3).roundUp(),
		position.y() + ((destino.y()-position.y())/3).roundUp()
		)
	}
	
	method image()= "img/" + self.perfil() +".png"
	
	method arriba(){
 		self.perfil("zombie_Arriba")				 
 	}
 	
 	method abajo(){
 		
 		self.perfil("zombie_Abajo")
 	}
 	
 	method derecha(){
 		
 		self.perfil("zombie_Der")
 	} 
 	
 	method izquierda(){
 		
 		self.perfil("zombie_izq")
 	}
}






class Potenciadores{
	const position
	var image 
	var tipo 
	method teAgarroJorge(){
		jorge.aumentar(tipo)
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
	
	
	method animarse(){
		
	}
	method position()= position
	
}

class Bala{
	var property position = null
	var property image = self.perfil()
	var property perfil = "funny_bala"
	
	method movDisparo(){
		game.onTick(1000 , "moverse",{self.disparo2()})
	}
	method disparoIni(){
		if (jorge.perfil() == "personaje_Arriba" && jorge.balas() != 0){
			self.perfil("funny_bala4")
			game.addVisual(self)
			jorge.balas() == jorge.balas() - 1
			position = jorge.position().up(1)
			self.movDisparo()
		}
		else if (jorge.perfil() == "personaje_Abajo" && jorge.balas() != 0){
			self.perfil("funny_bala2")
			game.addVisual(self)
			jorge.balas() == jorge.balas() - 1
			position = jorge.position().down(1)
			self.movDisparo()
		}
		else if (jorge.perfil() == "personaje_Der" && jorge.balas() != 0){
			self.perfil("funny_bala3")
			game.addVisual(self)
			jorge.balas() == jorge.balas().right(1)
			position = jorge.position() + position.x(1)
			self.movDisparo()
		}
		else if (jorge.perfil() == "personaje_izq" && jorge.balas() != 0){
			game.addVisual(self)
			jorge.balas() == jorge.balas().left(1)
			position = jorge.position() - position.x(1)
			self.movDisparo()
		}
		else{
			/*game.say(jorge,"No tengo balas")*/
		}
	}
	
	method disparo2(){
		if (image == "funny_bala4"){
			position.up(1)
		}
		else if (image == "funny_bala2"){
			position.down(1)
		}
		else if (image == "funny_bala3"){
			position.right(1)
		}
		else if (image == "funny_bala"){
			position.left(1)
		}
	}

}


