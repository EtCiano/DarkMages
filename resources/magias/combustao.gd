class_name combustao
extends magicData

var posMouse: Vector2
var distancia: float
var anguloMouse: float

func _init(personagemPos, mousePos) -> void:
	super()
	posMouse = mousePos
	posicaoPesonagem = personagemPos
	custoMana = 20.0
	espacosUsados = 1
	danoBase = 10.0
	cooldown = 1.0
	distancia = 100.0
	anguloMouse = atan2(
		posMouse.y - posicaoPesonagem.y,
		posMouse.x - posicaoPesonagem.x
	)
	conjurar()
	
func conjurar():
	nodeAtaque.global_position = Vector2(
		posicaoPesonagem.x+(distancia*cos(anguloMouse)), 
		posicaoPesonagem.y+(distancia*sin(anguloMouse))
		)
	print(anguloMouse, posMouse, posicaoPesonagem)
	var hitbox = adicionarFuncao(funcoesAtaques['hitbox'])
	var visual = adicionarFuncao(funcoesAtaques['visualCombustao'])
	var timer = adicionarFuncao(funcoesAtaques['timer'])
	
	var noiseShader = visual.material.get_shader_parameter("texturaRuido").noise
	noiseShader.seed = randi()
	visual.get_node("AnimationPlayer").play("default")
	
	hitbox.dano = danoBase
	hitbox.forma = CircleShape2D.new()
	hitbox.forma.radius = 64
	hitbox.definir()
	
	timer.start(1.0)
	#timer.timeout.connect(acabar.bind(nodeAtaque)) 
