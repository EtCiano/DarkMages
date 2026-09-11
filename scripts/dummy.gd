extends Node2D

func _ready() -> void:
	$inimigo.nome = 'Dummyzinho lindio'
	$inimigo.dano = 0
	$inimigo/Sprite2D.texture = load("res://sprites/dummy.png")
	$inimigo.forma = CapsuleShape2D.new()
	$inimigo.raio = 16.0
	$inimigo.altura = 66.0
	$inimigo.definir()
