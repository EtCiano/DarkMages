extends CharacterBody2D
const SPEED = 300.0

signal hit(hitbox: Area2D)

@onready var personagemInfo = get_node("atributosPersonagem")

func _physics_process(delta: float) -> void:
	calcularMovimento()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Ataque1"):
		personagemInfo.ataques[0].new(position)

func calcularMovimento() -> void:
	var directionX := Input.get_axis("esquerda", "direita")
	if directionX:
		velocity.x = directionX * SPEED
		$AnimatedSprite2D.animation = "andando"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.animation = "parado"
		
	if directionX < 0:
		$AnimatedSprite2D.flip_h = true
	if directionX > 0 and $AnimatedSprite2D.flip_h == true:
		$AnimatedSprite2D.flip_h = false
		
	var directionY := Input.get_axis("cima", "baixo")
	if directionY:
		velocity.y = directionY * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()

func _ready() -> void:
	
	$hitbox.area_entered.connect(_on_hitbox_area_entered)
	$hitbox.origem = Global.entidade.PLAYER
	
	$AnimatedSprite2D.animation = "parado"
	$AnimatedSprite2D.play()
	var corClasse = Color(1.0, 1.0, 1.0, 1.0)
	
	var classeJogador = personagemInfo.classeJogador
	
	match classeJogador:
		Global.classe.FEITICEIRO:
			corClasse = Color(0.0, 0.355, 0.66, 1.0)
		Global.classe.CLERIGO:
			corClasse = Color(0.897, 0.833, 0.388, 1.0)
		Global.classe.OCULTISTA:
			corClasse = Color(0.471, 0.0, 0.0, 1.0)
	$AnimatedSprite2D.material.set_shader_parameter("corClasse", corClasse)

func _on_hitbox_area_entered(hitBox: Area2D) -> void:
	hit.emit(hitBox)
