import example.*
import personajes.*
import wollok.game.*

object juegoTerminado{
	var property image = "img/gameOver.png"
	var property position = game.at(5,5)
	
	method sucede(){
		game.addVisual(self)
	}
}

object reloj {

    var tiempo = 0

    method text() = tiempo.toString()
    method textColor() = paleta.rojo()
    method position() = game.at(game.width()-1, game.height()-1)

    method pasarTiempo() {
        tiempo = tiempo + 1
    }
    method iniciar(){
        game.onTick(100,"tiempo",{self.pasarTiempo()})
    }
    method detener(){
        game.removeTickEvent("tiempo")
    }
 

}

	object paleta {
	const property rojo = "FF0000FF"
}

