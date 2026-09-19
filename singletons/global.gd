extends Node

const pixelSize: float = 4.0

const damageShower = preload("res://scenes/damage_shower.tscn")

const debug: bool = true

enum classe {FEITICEIRO, CLERIGO, OCULTISTA}
enum entidade {PLAYER, INIMIGO}
enum status {VIVO, MORTO}
	
func aplicar_modificacoes(no_alvo: Node, propriedades: Dictionary) -> void:
	if not is_instance_valid(no_alvo):
		push_error("O nó alvo é inválido ou foi deletado!")
		return

	for propriedade in propriedades:
		var novo_valor = propriedades[propriedade]
		no_alvo.set(propriedade, novo_valor)
		
func showDamage(entidadeAtacada: Node, sprite: Node, dano) -> void:
	var damageShow = damageShower.instantiate()
	entidadeAtacada.add_child(damageShow)
	damageShow.text = str(dano)
	var rect = sprite.get_rect()
	damageShow.position = Vector2(
		(rect.position.x+(rect.size.x/2))-damageShow.size.x,
		 rect.position.y-(damageShow.size.y)
	)

	#if debug:
		#var debugRect = ColorRect.new()
		#debugRect.size = rect.size
		#debugRect.position = rect.position
		#var debugStyle = StyleBoxFlat.new()
		#debugStyle.bg_color = Color(0,0,0,1)
		#debugStyle.border_color = Color.RED
		#debugStyle.set_border_width_all(2)
		#debugRect.add_theme_stylebox_override("panel", debugStyle)
		#sprite.add_child(debugRect)
#
		#var dmgStyle = StyleBoxFlat.new()
		#dmgStyle.bg_color = Color(0,0,0,1)
		#dmgStyle.border_color = Color.RED
		#dmgStyle.set_border_width_all(2)
		#damageShow.add_theme_stylebox_override("normal", dmgStyle)
	
