extends Node

var classeJogador = Global.classe.OCULTISTA
var mana = 100.0
var vida = 100.0

func _levarDano(dano: float) -> void:
	vida -= dano
