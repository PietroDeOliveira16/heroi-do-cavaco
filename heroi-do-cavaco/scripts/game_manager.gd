extends Node2D

const musicaSelecionadaMidi = preload("res://assets/songs/smells-like-teen-spirit-nirvana/smells-like-bass.mid")
const musicaSelecionadaAudio = preload("res://assets/songs/smells-like-teen-spirit-nirvana/Nirvana-Smells-Like-Teen-Spirit-_Official-Music-Video_.wav")

@export var menu: PackedScene
@export var jogo: PackedScene
@export var fimDeJogo: PackedScene

@export var medalhaPior: CompressedTexture2D = preload("res://assets/kenney_board-game-icons/PNG/Default (64px)/skull.png")
@export var medalhaBronze: CompressedTexture2D = preload("res://assets/kenneymedals/PNG/flatshadow_medal2.png")
@export var medalhaPrata: CompressedTexture2D = preload("res://assets/kenneymedals/PNG/flatshadow_medal3.png")
@export var medalhaOuro: CompressedTexture2D = preload("res://assets/kenneymedals/PNG/flatshadow_medal1.png")

var novoMenu
var novoJogo
var novoFimDeJogo

func _ready() -> void:
	addMenu()

func comecarJogo() -> void:
	for n in get_children():
		remove_child(n)
		n.queue_free()
	novoJogo = jogo.instantiate()
	novoJogo.musicaAtualMidi = musicaSelecionadaMidi
	novoJogo.musicaAtualAudio = musicaSelecionadaAudio
	novoJogo.velocidadeDasNotas = 370.0
	novoJogo.musicaAcabou.connect(mostrarTelaFimDeJogo)
	add_child(novoJogo)

func mostrarTelaFimDeJogo(pontuacao: int) -> void:
	novoFimDeJogo = fimDeJogo.instantiate()
	novoFimDeJogo.jogarNovamente.connect(comecarJogo)
	novoFimDeJogo.menu.connect(voltarMenu)
	add_child(novoFimDeJogo)
	if(pontuacao < 2500):
		novoFimDeJogo.sprite.texture = medalhaPior
	elif(pontuacao >= 2500 && pontuacao < 10000):
		novoFimDeJogo.sprite.texture = medalhaBronze
	elif(pontuacao >= 10000 && pontuacao < 45000):
		novoFimDeJogo.sprite.texture = medalhaPrata
	else:
		novoFimDeJogo.sprite.texture = medalhaOuro
	novoFimDeJogo.pontuacaoLabel.text = str(pontuacao)

func voltarMenu() -> void:
	for n in get_children():
		remove_child(n)
		n.queue_free()
	addMenu()
	
func addMenu() -> void:
	novoMenu = menu.instantiate()
	novoMenu.comecarJogo.connect(comecarJogo)
	add_child(novoMenu)
