class NaveEspacial {
	var velocidad = 0
	var direccion = 0
	var combustible = 0
	
	method acelerar(cuanto) {
		velocidad = (velocidad + cuanto).min(100000)
	}
	method desacelerar(cuanto) {
		velocidad = (velocidad - cuanto).max(0)
	}
	method irHaciaElSol() { direccion = 10 }
	method escaparDelSol() { direccion = -10 }
	method ponerseParaleloAlSol() { direccion = 0 }
	method prepararViaje(){
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	
	method acercarseUnPocoAlSol(){
		direccion = (direccion + 1).min(10)
	}
	
	method alejarseUnPocoDelSol(){
		direccion = (direccion - 1).max(-10)
	}
	
	method cargarCombustible(cuanto){
		combustible = combustible + cuanto
	}
	
	method descargarCombustible(cuanto){
		combustible = (combustible - cuanto).max(0)
	}
	
	method tranquila(){
		return combustible>=4000 && velocidad<=12000
	}
	
	method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	
	method escapar()
	
	method avisar()
	
	method relajada(){
		return self.tranquila() && self.pocaActividad()
	}
	
	method pocaActividad()//
}

class Baliza inherits NaveEspacial{
	var baliza ="azul"
	var controlBaliza = true
	
	method cambiarColorDeBaliza(colorNuevo){
		baliza = colorNuevo
		controlBaliza=false
	}
	
	override method prepararViaje(){
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()
	}
	
	override method tranquila(){
		return super() && baliza != "rojo"
	}
	
	override method escapar(){
		self.irHaciaElSol()
	}
	override method avisar(){
		self.cambiarColorDeBaliza("rojo")
	}
	
	override method pocaActividad(){
		return controlBaliza
	}
	
}

class Pasajeros inherits NaveEspacial{
	var property pasajeros
	var raciones = 0
	var bebidas = 0
	var racionesServidas = 0
	
	method cargarRaciones(cuanto){
		raciones = raciones + cuanto
	}
	
	method cargarBebidas(cuanto){
		bebidas = bebidas + cuanto
	}
	
	method descargarRaciones(cuanto){
		raciones = (raciones - cuanto).max(0)
		racionesServidas = racionesServidas+cuanto
	}
	
	method descargarBebidas(cuanto){
		bebidas = (bebidas - cuanto).max(0)
	}
	
	override method prepararViaje(){
		self.cargarRaciones(self.pasajeros()*4)
		self.cargarBebidas(self.pasajeros()*6)
		self.acercarseUnPocoAlSol()
	}
	
	override method escapar(){
		velocidad= velocidad*2
	}
	override method avisar(){
		self.descargarRaciones(pasajeros)
		self.descargarBebidas(pasajeros*2)
	}
	
	override method pocaActividad(){
		return racionesServidas<50
	}

}

class Combate inherits NaveEspacial{
	var invisible = false
	var misiles = false
	const property mensajes = []
	
	method ponerseVisible(){
		invisible = false
	}
	
	method ponerseInvisible(){
		invisible = true
	}
	
	method estaInvisible(){
		return invisible
	}
	
	method desplegarMisiles(){
		misiles = true
	}
	
	method replegarMisiles(){
		misiles = false
	}
	
	method misilesDesplegados(){
		return misiles
	}
	
	method emitirMensaje(mensaje){
		mensajes.add(mensaje)
	}
	
	method mensajesEmitidos(){
		return mensajes.size()
	}
	
	method primerMensajeEmitido(){
		if(mensajes.isEmpty()) self.error("no hay mensajes")//
		return mensajes.first()
	}
	
	method ultimoMensajeEmitido(){
		if(mensajes.isEmpty()) self.error("no hay mensajes")//
		return mensajes.last()
	}
	
	method esEscueta(){
		//return !mensajes.any({m=>m.size()>30})//
		return mensajes.all({m=>m.size()<=30})
	}
	
	method emitioMensaje(mensaje){
		return mensajes.contains(mensaje)//
		//return mensajes.any({m=>m==mensaje})
	}
	
	override method prepararViaje(){
		self.ponerseVisible()
		self.replegarMisiles()
		self.acelerar(15000)
		self.emitirMensaje("Saliendo en misión")
		self.acelerar(5000)
		self.acelerar(10000)
	}
	
	override method tranquila(){
		return super() && !self.misilesDesplegados()
	}
	
	override method escapar(){
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	override method avisar(){
		self.emitirMensaje("Amenaza recibida")
	}
	
	override method pocaActividad(){
		return self.esEscueta()
	}
	
	
}

class Hospital inherits Pasajeros{
	var quirofanos = false
	
	method prepararQuirofano(){
		quirofanos = true
	}
	
	override method tranquila(){
		return super() && !quirofanos
	}
	
	override method recibirAmenaza(){
		super()
		self.prepararQuirofano()
	}
	
}

class CombateSigilosa inherits Combate{
	
	override method tranquila(){
		return super() && !self.estaInvisible()
	}
	
	override method escapar(){
		super()
		self.desplegarMisiles()
		self.ponerseInvisible()
	}
	
}



