class_name combustao
extends magicData

func _init(personagemPos, personagemDirecao) -> void:
	super()
	posicaoPesonagem = personagemPos
	direcaoPersonagem = personagemDirecao
	custoMana = 20.0
	danoBase = 20.0
	espacosUsados = 1
	danoBase = 10.0
	conjurar()
	
func conjurar():
	nodeAtaque.position = Vector2(posicaoPesonagem.x+(50*direcaoPersonagem), posicaoPesonagem.y)
	var hitbox = adicionarFuncao(funcoesAtaques['hitbox'])
	var visual = adicionarFuncao(funcoesAtaques['visual'])
	var timer = adicionarFuncao(funcoesAtaques['timer'])
	
	hitbox.dano = danoBase
	hitbox.forma = CircleShape2D.new()
	hitbox.forma.radius = 64
	hitbox.definir()
	
	visual.texture = load("res://resources/radialGradient.tres")
	visual.material = load("res://shaders/shaderFogo.tres")
	
	timer.start(1.0)
	#timer.timeout.connect(acabar.bind(nodeAtaque)) 
