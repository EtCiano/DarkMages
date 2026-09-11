extends Node

const pixelSize: float = 4.0

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
