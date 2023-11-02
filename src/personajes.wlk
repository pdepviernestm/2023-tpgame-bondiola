import wollok.game.*
import example.*
import Fondos.*


object jorge {
	var property position = game.center()
	var property vidas = 3
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
		 if(tipo == "vida"){
		 	if(self.vidas() < 3 )
		 	self.ganarVida()
		 	
			 }
		 else{
		 	balas += 3
		 }
	}
	
	
	
	method perderVida(){
		vidas -= 1
		if(self.vidas() == 2){
			game.removeVisual(corazon3)
			game.addVisual(corazonNegro3)
		}else if(self.vidas()==1){
			game.removeVisual(corazon2)
			game.addVisual(corazonNegro2)
		}else if(self.vidas()==0){
				juego.gameOver()
				
			 
		}
	}
	method ganarVida(){
		if(self.vidas() == 2 ){
			game.removeVisual(corazonNegro3)
			game.addVisual(corazon3)
		}else if(self.vidas()==1){
			game.removeVisual(corazonNegro2)
			game.addVisual(corazon2)
		}
		vidas++
}


	
	
	method vidas() = vidas
	
	method disparar(){
		if (balas > 0){
			const bala = new Bala(position = self.position() , image=self.image())
		    bala.orientacionBala()
		    game.addVisual(bala)
		    bala.movDisparo()
		    balas -= 1
		    
		}
		else{
			game.say(self,"no tengo balas.")
		}
		
	}
	
	method efectoBala(balaQueDio){}
}   


/*ZOMBIES */
class Zombies {
	var property position = null
	var property image = self.perfil()
	var property perfil = "zombie_Abajo"
	method teAgarroJorge(){
		jorge.perderVida()
		if(jorge.vidas() > 0){	
		game.say(jorge,"Me quedan " + jorge.vidas() + " vidas.")
		self.desaparecer()
		}
	
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
 	method morir(){
 		game.onCollideDo(self,{elemento=> elemento.teChocoLaBala()})
 	}
 	method efectoBala(balaQueDio){
 		self.desaparecer()
 		game.removeVisual(balaQueDio)
 	}
 	
 	
}