class_name combustao
extends magicData

func _init(personagemPos) -> void:
	super()
	posicaoPesonagem = personagemPos
	custoMana = 20.0
	danoBase = 20.0
	espacosUsados = 1
	danoBase = 10.0
	conjurar()
	
func conjurar():
	nodeAtaque.position = Vector2(posicaoPesonagem.x+50, posicaoPesonagem.y)
	var hitbox = adicionarFuncao(funcoesAtaques['hitbox'])
	var visual = adicionarFuncao(funcoesAtaques['visual'])
	var timer = adicionarFuncao(funcoesAtaques['timer'])
	
	hitbox.dano = danoBase
	hitbox.forma = CircleShape2D.new()
	hitbox.raio = 10.0
	hitbox.definir()
	
	visual.textura = load("res://icon.svg")
	visual.definir()
	
	timer.tempo = 2.0
	timer.definir()
	#timer.timeout.connect(acabar.bind(nodeAtaque))
	
	
	
	# TODO: Adicionar os nós para os ataques (hitbox, particula, projétil, etc) no estilo do jujutsu shenanigans 😭 
