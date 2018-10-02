class VagonPasajeros{
	var property largo = 0 
	var property anchoUtil = 0
		
	method cantPasajeros(){
		if (anchoUtil <= 2.5) {
			return largo*8
			}
		else{
			return largo*10
		}
	}
	method pesoMax(){
		return self.cantPasajeros()*80
	} 
}

class VagonCarga{
	var property cargaMax = 0
	
	method pesoMax(){
		return cargaMax+160
	}
	method cantPasajeros(){
		return 0
	}
}

class Locomotora{
	var property peso = 0
	var property arrastreUtil = 0
	var property velocidadMax = 0
	
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
	method cantUnidades(){
		return locomotoras.size() + vagonesTotal.size()
	}
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

class Deposito{
	var property formaciones = []
	var property locomotorasSueltas = []
	var property conjuntoVagonesPesados = []
	
	method conjuntoVagones(){
//		return formaciones.filter{formacion=>formacion.vagonMasPesado()}
//		conjuntoVagonesPesados.add{formaciones.filter{formacion=>formacion.vagonMasPesado()}}
//		conjuntoVagonesPesados.add{formaciones.all{formacion=>formacion.vagonMasPesado()}}
//		conjuntoVagonesPesados.add{formaciones.forEach{formacion=>formacion.vagonMasPesado()}}
	}
	method conductorExperimentado(){
		return formaciones.any{formacion=>formacion.compleja()}
	}
	method agregarLocomotoraEnFormacion(formacion){
		if (!formacion.puedeMoverse())
			formacion.locomotoras().add(locomotorasSueltas.find{locomotora=>locomotora.arrastreUtil()>=formacion.empuje()})
	}	
}
