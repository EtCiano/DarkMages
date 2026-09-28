# AGENTS.md

Jogo 2D de magias em Godot 4.7 (`godot` = 4.7.2.stable). Sem build, sem CI, sem lint, sem testes
automatizados, sem `.gitignore`. Identificadores, comentários e nomes de arquivo são em português,
misturando camelCase (`custoMana`, `anguloMouse`, `posMouse`) e snake_case (`cor_da_borda`,
`no_alvo`, `hitBox`). Indentação com tabs.

## Comandos (verificados)

```bash
godot --headless --path . --editor --quit      # importa, gera .gd.uid e o cache de class_name
godot --headless --path . --quit-after 240     # smoke run do main.tscn (exit 0 = sem erro de script)
godot --headless --path . --script res://x.gd # checagem pontual: script estende SceneTree
```

- Rode o `--editor --quit` depois de criar `.gd`/`.tscn`: é ele que gera os `.gd.uid` e registra
  `class_name` globais. Sem ele, os arquivos novos aparecem sem uid.
- O smoke run é headless: erros de GDScript e de `_ready` aparecem, **shader não compila** — mudanças
  de `.gdshader`/`.tres` só podem ser validadas rodando o jogo.
- Em `--script`, um script que estende `SceneTree` recebe `_process(delta) -> bool` (`true` = sai).
  `@onready` **não** resolve dentro de `_initialize()`: o nó precisa estar na árvore e o root do
  `SceneTree` pronto, ou seja, a partir do primeiro `_process`.
- `project.godot` referencia a cena principal **por uid** (`run/main_scene="uid://ckapnesoei3lg"`).
  Recriar `scenes/main.tscn` sem copiar o uid quebra o arranque do jogo.
- O `--editor --quit` headless tem dois efeitos colaterais: às vezes grava
  `window/size/mode=3` (fullscreen) no `project.godot` — reverta com `git checkout project.godot` —, e
  **recria** no disco qualquer cena que ainda esteja em `open_scenes`/`current_scene` de
  `.godot/editor/editor_layout.cfg` (mesmo já tendo sido apagada no git). Antes de apagar uma cena
  com `rm`/`git rm`, tire ela do estado do editor; se ela voltar, apague de novo **sem** rodar o
  import.

## Arquitetura de ataques (o núcleo do projeto)

Um ataque é uma **cena**, não uma `Resource`. Nada de nós criados por script em runtime.

- `scenes/ataque.tscn` — a cena base: **só** um `Area2D` com `scripts/scriptsAtaques/ataque.gd`
  (`class_name Ataque`). Guarda os dados genéricos (`custoMana`, `danoBase`, `espacosUsados`,
  `classeUsada`, `cooldown`, `conjurador`) e os helpers `aplicar_dano(hitbox)`,
  `angulo_ate(origem, alvo)`, `ponto_a_distancia(origem, angulo, distancia)`.
- `scenes/ataques/<magia>/<magia>.tscn` — a subclasse: raiz `Node2D` com `<magia>.gd`
  (`class_name <magia>`) que **instancia `ataque.tscn` como filho `ataque`** e, no mesmo nível,
  os nós da magia (`hitbox`, `visual`, `TimerAtaque` — este último de `scenes/nosAtaques/`).
  Só o que é específico da magia fica aqui; visual próprio mora na pasta da magia
  (`scenes/ataques/combustao/visual_combustao.tscn`).
- `scenes/nosAtaques/` = templates de nós reutilizados por magias **e** por entidades
  (`hitbox.tscn`, `timer_ataque.tscn`).

Contrato que toda subclasse respeita:

```gdscript
func conjurar(posicaoPersonagem: Vector2, mousePos: Vector2) -> void   # chamado pelo conjurador
var cooldown: float: get: return ataque.cooldown                        # lido pelo conjurador
```

Fluxo do conjurador (`personagem.gd` → `conjurarAtaque(indice)`):
`personagemInfo.ataques[indice].instantiate()` (`Array[PackedScene]` em `infoPersonagem.gd`) →
`get_tree().current_scene.add_child(...)` → `ataque.conjurar(global_position, get_global_mouse_position())`
→ `$timers/timerAtaque1.start(ataque.cooldown)`. O `add_child` precisa vir **antes** da leitura de
`cooldown`, porque o getter depende do `@onready var ataque`.

Para criar uma magia: pasta nova em `scenes/ataques/`, instanciar `ataque.tscn`, adicionar os nós na
cena (não no script), script com `class_name <magia>` + `conjurar()`, e registrar a `PackedScene` em
`infoPersonagem.ataques`. Hitbox: exporte `forma` na cena e chame `hitbox.definir()` — hitbox sem
shape no `CollisionShape2D` nunca emite `area_entered`, logo nunca causa dano.

## Dano

`Area2D` hitbox → `area_entered` → signal `hit` da entidade → `_levarDano()` em
`atributosPersonagem` (jogador) ou `infoInimigo` (inimigo), que só aplica se
`hitBox.origem != tipoEntidade` e chama `Global.showDamage()`. `origem` = `Global.entidade` de quem
conjurou. `Global` é autoload (`singletons/global.gd`): enums `classe`, `entidade`, `status`,
constantes `pixelSize`/`debug`, `showDamage()`, `aplicar_modificacoes()`. `Global.debug` liga o
contorno de debug da hitbox e é usado em tipos `@export var x: Global.entidade`.

## Fim do ataque

`nosAtaques/timer_ataque.tscn` é um `Timer` `one_shot` + `autostart` cujo script faz
`get_node("..").queue_free()`. Como é filho da cena da magia, ele libera a magia inteira. A duração
é o `wait_time` da cena (o antigo `tempoTotal` foi removido — não reintroduza).

## Convenções

- Script ao lado da cena quando o script pertence àquela entidade (`personagem/personagem.gd` +
  `mago_personagem.tscn`); scripts de nós de ataque ficam em `scripts/scriptsAtaques/`.
- `class_name` é usado só onde faz falta: `Ataque` e uma classe por magia. Scripts de nós de
  entidade não têm `class_name` e são acessados por `$caminho`.
- Dados vão em `@export` e são editados no inspector; a cena é a fonte da verdade.
- `.gd.uid` é versionado junto do script — apague os dois juntos.
- `.godot/` **está versionado** (centenas de arquivos de cache/editor). Diff vai ficar sujo; não
  tente limpá-lo nem adicionar `.gitignore` sem pedido.
- Ao escrever `.tscn` na mão: `uid` e `unique_id` podem ser omitidos (Godot regenera);
  sobreposição de propriedade vale na raiz da instância (`instance=ExtResource(...)`); para
  alterar um filho de uma instância é preciso `[editable path="..."]`.
- Input: WASD + `Ataque1` (tecla 1 / botão esquerdo). Personagem tem 4 slots de cooldown em
  `mago_personagem.tscn` (`timers/timerAtaque1..4`), mas só o índice 0 está ligado no código.
- Pixel art: filtro nearest já em `project.godot` (`default_texture_filter=0`); classe do jogador é
  aplicada no shader por `corClasse` (`personagem.gd` + `personagem_shader.tres`).

## Armadilhas conhecidas

- `shaders/shaderFogo.tres` é um `ShaderMaterial` **compartilhado**: o `noise.seed = randi()` em
  `combustao.acender()` muda o ruído de todas as combustões. Para variação por ataque, duplique o
  material dentro da cena.
- `visual_combustao.tscn` anima `texture:fill_to` do `radialGradient.tres` pela animação
  `"default"`.
- O hitbox do jogador (`mago_personagem.tscn`) não tem shape e ninguém chama `definir()` nele, então
  o jogador hoje não toma dano. O do dummy recebe shape pelo `definir()` próprio do `inimigo.gd`,
  que é separado do `hitbox.gd`.
- `.tscn` e `.gd` guardam nós por caminho (`$hitbox`, `$visual/AnimationPlayer`): renomear nó quebra
  a cena silenciosamente em runtime.

## Ataque que se move (projétil)

Não existe nó "projétil": a raiz `Node2D` da cena **é** o projétil, então a hitbox filha acompanha o
movimento sozinha. O movimento fica no script da subclasse, em `_physics_process` (o mesmo tick do
`Area2D`, o que evita atravessar hitboxes), e a duração sai do `TimerAtaque` que já existe
(`wait_time = alcance / velocidade`), sem nenhum código a mais:

```gdscript
func conjurar(posicaoPersonagem: Vector2, mousePos: Vector2) -> void:
	anguloMouse = ataque.angulo_ate(posicaoPersonagem, mousePos)
	global_position = posicaoPersonagem   # projétil nasce no conjurador
	rotation = anguloMouse                # e vira para o mouse (o visual gira junto)
	$hitbox.definir()
	ataque.aplicar_dano($hitbox)

func _physics_process(delta: float) -> void:
	global_position += Vector2.RIGHT.rotated(rotation) * velocidade * delta
```

- `Vector2.RIGHT.rotated(rotation)` é a direção do nó. Se a arte já aponta para a direita, `rotation`
  basta; se apontar para a esquerda, use `rotation + PI` (ou `flip_h` no visual).
- `rotation` gira a subárvore inteira: para a hitbox isso é o comportamento correto, mas o `offset`
  do visual precisa estar centrado (ou deslocado para a "boca" do projétil).
- Escolha `global_position` **ou** `position` e use o mesmo nos dois lugares — misturar dá drift.
- Curva/homing: `rotate_toward()` dentro do `_physics_process`, ou um `Tween` criado no `conjurar()`.
- "O que acontece ao acertar" (atravessar ou sumir no primeiro acerto) foi discutido como um
  `@export ao_acertar` na `hitbox.gd`, com a hitbox ouvindo o próprio `area_entered`: **não
  implementado**, não criar sem pedido.
