extends Node

const pixelSize: float = 4.0

const damageShower = preload("res://scenes/damage_shower.tscn")

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
		
func showDamage(entidade, sprite: Sprite2D, dano) -> void:
	var damageShow = damageShower.instantiate()
	entidade.add_child(damageShow)
	damageShow.text = str(dano)
	if sprite and sprite.get_rect().size.x > 0.0:
		var rect = sprite.get_rect()
		damageShow.position = sprite.position + (rect.position + rect.size / 2.0) * sprite.scale
	else:
		damageShow.position = Vector2.ZERO
	
