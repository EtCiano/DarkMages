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
	cooldown = 1.0
	conjurar()
	
func conjurar():
	nodeAtaque.position = Vector2(posicaoPesonagem.x+(100*direcaoPersonagem), posicaoPesonagem.y)
	var hitbox = adicionarFuncao(funcoesAtaques['hitbox'])
	var visual = adicionarFuncao(funcoesAtaques['visualCombustao'])
	var timer = adicionarFuncao(funcoesAtaques['timer'])
	
	hitbox.dano = danoBase
	hitbox.forma = CircleShape2D.new()
	hitbox.forma.radius = 64
	hitbox.definir()
	
	var noiseShader = visual.material.get_shader_parameter("texturaRuido").noise
	noiseShader.seed = randi()
	visual.get_node("AnimationPlayer").play("default")
	
	timer.start(1.0)
	#timer.timeout.connect(acabar.bind(nodeAtaque)) 
