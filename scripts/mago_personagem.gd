extends CharacterBody2D
const SPEED = 300.0

func _physics_process(delta: float) -> void:
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
	$AnimatedSprite2D.animation = "parado"
	$AnimatedSprite2D.play()
	var corClasse = Color(1.0, 1.0, 1.0, 1.0)
	
	match PersonagemInfo.classe_jogador:
		PersonagemInfo.classe.FEITICEIRO:
			corClasse = Color(0.0, 0.55, 1.0, 1.0)
		PersonagemInfo.classe.CLERIGO:
			corClasse = Color(0.897, 0.833, 0.388, 1.0)
		PersonagemInfo.classe.OCULTISTA:
			corClasse = Color(0.471, 0.0, 0.0, 1.0)
	$AnimatedSprite2D.material.set_shader_parameter("corClasse", corClasse)
