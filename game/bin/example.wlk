
/*HACER QUE LOS ZOMBIES CAMBIEN DE DIRECCION 
 * 
 * */

import wollok.game.*

object juego {
	method iniciar(){
		
		game.width(20)
		game.height(14)
		game.addVisualCharacter(jorge)	
		
		game.onCollideDo(jorge , {algo => algo.teAgarroJorge()})
		
		 keyboard.up().onPressDo( {jorge.moverArriba()})
		 keyboard.right().onPressDo( {jorge.moverDerecha()})
		 keyboard.left().onPressDo( {jorge.moverIzquierda()})
		 keyboard.down().onPressDo( {jorge.moverAbajo()})
		
		
		
		self.generarZombies()
		self.generarPotenciadores()
		/* A LOS 20 SEGUNDOS DESAPARECEN TODOS LOS ZOMBIES */
		game.schedule(20000,{game.removeTickEvent("aparece zombie")})
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
	
	var municion = 10 
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
	
	
} 


/*ZOMBIES */
class Zombies {
	var property position = null
	
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
		game.onTick(1000 , "acercarse",{self.darUnPaso(jorge.position())})
	}
	
	method darUnPaso(destino){
		position = game.at(
		position.x() + (destino.x()-position.x())/3,
		position.y() + (destino.y()-position.y())/3
		)
	}
	
	method image()= "img/zombie_Abajo.png "
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




object movimientos {
	method moverUp(objeto){
		
	}
	
	method moverDown(objeto,number){
		objeto.position(objeto.position().down(1))
	}
	
	method moverRight(objeto,number){
		objeto.position(objeto.position().right(1))
	}
	
	method moverLeft(objeto,number){
		objeto.position(objeto.position().left(1))
	}
	
}