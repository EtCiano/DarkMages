class_name magicData
extends Resource

var custoMana: float
var danoBase: float
var espacosUsados: int
var classeUsada: Global.classe
var tempoTotal: float

var conjurador: Global.entidade

func acabar(node) -> void:
	node.queue_free()
