class VagonPasajeros{
	const property largo = 0 
	const property anchoUtil = 0
	const property cantBanios = 0
		
	method cantPasajeros(){
		return largo * (if (anchoUtil <= 2.5) 8 else 10)
	}
	method pesoMax(){
		return self.cantPasajeros()*80
	} 
}

class VagonCarga{
	const property cargaMax = 0
	
	method cantPasajeros() = 0
	method cantBanios() = 0
	method pesoMax(){
		return cargaMax+160
	}
}

class Locomotora{
	const property peso = 0
	const property arrastreUtil = 0
	const property velocidadMax = 0
	
	method pesoMaxArrastra(){
		return peso + arrastreUtil
	}
}

class Formacion{
	var property locomotoras = [] 
	var property vagonesTotal = [] 
	
	method pesoMaxArrastraTotal(){
		return locomotoras.sum{locomotora=>locomotora.pesoMaxArrastra()}	
	}
	method arrastreUtilTotal(){
		return locomotoras.sum{locomotora=>locomotora.arrastreUtil()}	
	}
	method pesoMaxTotalVagones(){
		return vagonesTotal.sum{vagon=>vagon.pesoMax()}
	}
	method pesoTotal(){
		return self.pesoMaxArrastraTotal() + self.pesoMaxTotalVagones()
	}
	method cantUnidades() = locomotoras.size() + vagonesTotal.size()
	method totalPasajeros(){
		return vagonesTotal.sum{vagon=>vagon.cantPasajeros()}
	}
	method vagonMasPesado(){
		return vagonesTotal.max{vagon=>vagon.pesoMax()}
	}
	method vagonesLivianos(){
		return vagonesTotal.count{vagon=>vagon.pesoMax()<2500}
	}
	method velocidadMax(){
		return locomotoras.min{locomotora=>locomotora.velocidadMax()}.velocidadMax()
	}
	method eficiente(){
		return locomotoras.all{locomotora=>locomotora.pesoMaxArrastra()>=locomotora.peso()*5} 
	}
	method puedeMoverse(){
		return self.arrastreUtilTotal() >= self.pesoMaxTotalVagones()
	}
	method empuje(){
		if (self.puedeMoverse())
			return 0
		else
			return self.pesoMaxTotalVagones() - self.arrastreUtilTotal()
	}
	method compleja(){
		return (self.cantUnidades()>20) or (self.pesoTotal()>10000)
	}
}

class FormacionCortaDistancia inherits Formacion{
	method bienArmada() = self.puedeMoverse() && !self.compleja()
	method velocidadMaxFormacion() = self.velocidadMax().min(60)
}

class FormacionLargaDistancia inherits Formacion{
	const property origen = null
	const property destino = null
	
	method bienArmada() = self.puedeMoverse() && self.baniosSuficientes()
	method baniosSuficientes() = self.totalPasajeros()/50 <= self.cantBanios()
	method cantBanios() = self.vagonesTotal().sum{vagon=>vagon.cantBanios()}
	method velocidadMaxFormacion() = self.velocidadMax().min(self.velocidadLimite())
	method velocidadLimite(){
		return (if (origen.grande() and destino.grande()) 200 else 150)
	}
}

class Ciudad{
	const property grande = false
}

class Deposito{
	var property formaciones = []
	var property locomotorasSueltas = []
	
	method conjuntoVagones(){
		return formaciones.map{formacion=>formacion.vagonMasPesado()}
	}
	method conductorExperimentado(){
		return formaciones.any{formacion=>formacion.compleja()}
	}
	method agregarLocomotoraEnFormacion(formacion){
		if (!formacion.puedeMoverse())
			formacion.locomotoras().add(self.buscarLocomotoraSueltaApta(formacion))
	}	
	method buscarLocomotoraSueltaApta(formacion){
		return locomotorasSueltas.find{locomotora=>locomotora.arrastreUtil()>=formacion.empuje()}
	}
}
