extends Node

var classeJogador = Global.classe.OCULTISTA
var mana = 100.0
var vida = 100.0
var tipoEntidade = Global.entidade.PLAYER
var status = Global.status.MORTO
var personagemNode: Node
@export var ataques: Array[PackedScene] = [
	preload("res://scenes/ataques/combustao/combustao.tscn")
]

func _ready() -> void:
	personagemNode = get_node('.')

func _levarDano(hitBox: Area2D) -> void:
	if hitBox.origem != tipoEntidade:
		vida -= hitBox.dano
		Global.showDamage(personagemNode, $AnimatedSprite2D, hitBox.dano)
		if vida <= 0:
			status = Global.status.MORTO
			print('morreu o minino')
