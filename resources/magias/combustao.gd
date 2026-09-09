class_name combustao
extends magicData

func _init() -> void:
	custoMana = 20.0
	danoBase = 20.0
	espacosUsados = 1
	danoBase = 10.0
	conjurar()
	
func conjurar():
	var hitbox = adicionarFuncao(funcoesAtaques['hitbox'])
	var visual = adicionarFuncao(funcoesAtaques['visual'])
	var timer = adicionarFuncao(funcoesAtaques['timer'])
	
	hitbox.forma = CircleShape2D
	hitbox.raio = 10.0
	hitbox.definir()
	
	visual.textura = "res://icon.svg"
	visual.definir()
	
	timer.timeout.connect(acabar.bind(nodeAtaque))
	
	
	
	# TODO: Adicionar os nós para os ataques (hitbox, particula, projétil, etc) no estilo do jujutsu shenanigans 😭 
