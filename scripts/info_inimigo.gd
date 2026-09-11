extends Node

var nome: String
var mana = 100.0
var vida = 100.0
var tipoEntidade = Global.entidade.INIMIGO
var status = Global.status.VIVO

func _ready() -> void:
	get_node(".").hit.connect(_levarDano)

func _levarDano(hitBox: Area2D) -> void:
	if hitBox.origem != tipoEntidade:
		vida -= hitBox.dano
	if vida <= 0:
		status = Global.status.MORTO
		print('Morreu o minino lindio')
