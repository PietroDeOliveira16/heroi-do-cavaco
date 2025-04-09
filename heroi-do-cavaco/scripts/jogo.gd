extends Node2D

@export var img_nota1: CompressedTexture2D = preload("res://assets/kenney_board-game-icons/PNG/Default (64px)/d2-red.png")
@export var img_nota2: CompressedTexture2D = preload("res://assets/kenney_board-game-icons/PNG/Default (64px)/d2.png")
@export var img_nota3: CompressedTexture2D = preload("res://assets/kenney_board-game-icons/PNG/Default (64px)/d2-green.png")
@export var img_nota4: CompressedTexture2D = preload("res://assets/kenney_board-game-icons/PNG/Default (64px)/d2-blue.png")

@export var cenaNota: PackedScene
@export var cenaCaptador: PackedScene

@export var musicaAtualMidi: MidiResource
@export var musicaAtualAudio: AudioStream

@onready var pontosLabel: Label = $Pontuacao
@onready var desempenhoLabel: Label = $Desempenho
@onready var midiPlayer: MidiPlayer = $MidiPlayer
@onready var audioPlayer: AudioStreamPlayer = $AudioStreamPlayer
@onready var timerMusica: Timer = $Timer2
@onready var playerErro: AudioStreamPlayer2D = $Erro
@onready var multiplicadorLabel: Label = $MultiplicacaoCombo

var captadores = []
var posicaoXCaptador: int = -180

var podeInvocarNota: bool = true
var rng = RandomNumberGenerator.new()
var notaAtual: int = 1

var pontuacao: int = 0
var combo: int = 1
var comboMax: int = 10
var precisaoPerfeita: int = 4
var precisaoImperfeita: int = 2

var viewportSize: Vector2

const FA:String = "53"
const LA_SUS:String = "58"
const DO:String = "60"
const SOL_SUS:String = "56"
const DO_SUS:String = "61"
const FA_SUS:String = "54"
const LA:String = "57"
const RE_SUS:String = "51"

@export var velocidadeDaMusica: float = 370.0

func _ready() -> void:
	viewportSize = get_viewport_rect().size
	criarCaptadores()
	desempenhoLabel.position.x = viewportSize.x/2 + 220
	desempenhoLabel.position.y = viewportSize.y - 90
	midiPlayer.midi = musicaAtualMidi
	audioPlayer.stream = musicaAtualAudio
	midiPlayer.note.connect(my_note_callback)
	
	multiplicadorLabel.text = "(" + str(combo) + "x)"
	
	midiPlayer.link_audio_stream_player([audioPlayer])
	
	midiPlayer.play()
	
func criarCaptadores() -> void:
	captadores = [cenaCaptador.instantiate(), cenaCaptador.instantiate(), cenaCaptador.instantiate(), cenaCaptador.instantiate()]
	for i:int in range(captadores.size()):
		captadores[i].position.x = viewportSize.x/2 + posicaoXCaptador
		captadores[i].position.y = viewportSize.y - 70
		captadores[i].numero = i + 1
		captadores[i].clicouNaNota.connect(_captador_clicou_na_nota)
		captadores[i].errouANota.connect(_captador_errou_a_nota)
		posicaoXCaptador += 100
		add_child(captadores[i])

func gerarNota(posicaoNota: int) -> void:
	var nota = cenaNota.instantiate()
	var viewportSize2: Vector2 = get_viewport_rect().size
	nota.notaCaiu.connect(_nota_caiu_da_tela)
	nota.velocidade = velocidadeDaMusica
	add_child(nota)
	if(posicaoNota == 1):
		nota.sprite.texture = img_nota1
		nota.position.x = viewportSize2.x/2 - 180
	elif(posicaoNota == 2):
		nota.sprite.texture = img_nota2
		nota.position.x = viewportSize2.x/2 - 80
	elif(posicaoNota == 3):
		nota.sprite.texture = img_nota3
		nota.position.x = viewportSize2.x/2 + 20
	else:
		nota.sprite.texture = img_nota4
		nota.position.x = viewportSize2.x/2 + 120
		notaAtual = 0

func _captador_clicou_na_nota(area: Area2D, pontos: int, texto: String, cor: Color, precisao: int) -> void:
	area.queue_free()
	if(precisao == precisaoPerfeita && combo < comboMax):
		combo += 1
	if(precisao <= precisaoImperfeita):
		combo = 1
	multiplicadorLabel.text = "(" + str(combo) + "x)"
	pontuacao += (pontos * combo)
	pontosLabel.text = str(pontuacao).pad_zeros(7)
	desempenhoLabel.text = texto
	desempenhoLabel.add_theme_color_override("font_color", cor)

func _captador_errou_a_nota() -> void:
	_perder_pontos((pontuacao * 0.05))
	combo = 1
	multiplicadorLabel.text = "(" + str(combo) + "x)"
	desempenhoLabel.text = "Errou!"
	desempenhoLabel.add_theme_color_override("font_color", Color.RED)
	playerErro.play(1.3)

func _nota_caiu_da_tela() -> void:
	_perder_pontos((pontuacao * 0.1))
	combo = 1
	multiplicadorLabel.text = "(" + str(combo) + "x)"
	desempenhoLabel.text = "Errou!"
	desempenhoLabel.add_theme_color_override("font_color", Color.RED)
	
func _perder_pontos(pontos: int) -> void:
	pontuacao -= pontos
	if(pontuacao < 0):
		pontuacao = 0
	pontosLabel.text = str(pontuacao).pad_zeros(7)

func my_note_callback(event, track):
	if (event['subtype'] == MIDI_MESSAGE_NOTE_ON): # note on
		match str(event['note']):
			DO:
				gerarNota(1)
			DO_SUS:
				gerarNota(1)
			RE_SUS:
				gerarNota(4)
			FA:
				gerarNota(3)
			FA_SUS:
				gerarNota(2)
			SOL_SUS:
				gerarNota(4)
			LA:
				gerarNota(2)
			LA_SUS:
				gerarNota(2)
	elif (event['subtype'] == MIDI_MESSAGE_NOTE_OFF): # note off
		pass
	print("[Track: " + str(track) + "] Note played: " + str(event['note']))
