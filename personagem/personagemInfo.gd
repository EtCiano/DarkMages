extends Node

var classe_jogador = Global.OCULTISTA
var mana = 100.0
var vida = 100.0


func _levarDano(dano: float) -> void:
	vida -= dano
