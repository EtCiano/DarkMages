class_name magicData
extends Resource

var funcoesAtaques = {
	'hitbox': preload("res://scenes/nosAtaques/hitbox.tscn"),
	'timer': preload("res://scenes/nosAtaques/timer_ataque.tscn"),
	'visual': preload("res://scenes/nosAtaques/visual.tscn")
}

var custoMana: float
var danoBase: float
var espacosUsados: int
var classeUsada: Global.classe
var tempoTotal: float
var conjurador: Global.entidade

var cenaAtaque = preload("res://scenes/ataque.tscn")

var cenaAtual = Engine.get_main_loop() as SceneTree
var nodeAtaque: Node
var posicaoPesonagem: Vector2
var direcaoPersonagem: int

func _init() -> void:
	nodeAtaque = cenaAtaque.instantiate()
	cenaAtual.current_scene.add_child(nodeAtaque)

func acabar(node) -> void:
	node.queue_free()
	
func adicionarFuncao(funcao):
	var noFuncao = funcao.instantiate()
	nodeAtaque.add_child(noFuncao)
	return noFuncao
