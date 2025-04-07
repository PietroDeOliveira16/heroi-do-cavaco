extends Node2D

@export var img_nota1: CompressedTexture2D = preload("res://assets/kenney_board-game-icons/PNG/Default (64px)/d2-red.png")
@export var img_nota2: CompressedTexture2D = preload("res://assets/kenney_board-game-icons/PNG/Default (64px)/d2.png")
@export var img_nota3: CompressedTexture2D = preload("res://assets/kenney_board-game-icons/PNG/Default (64px)/d2-green.png")
@export var img_nota4: CompressedTexture2D = preload("res://assets/kenney_board-game-icons/PNG/Default (64px)/d2-blue.png")

@export var cenaNota: PackedScene
@export var cenaCaptador: PackedScene

@onready var timer: Timer = $Timer
@onready var pontosLabel: Label = $Pontuacao
@onready var desempenhoLabel: Label = $Desempenho
@onready var midiPlayer: MidiPlayer = $MidiPlayer
@onready var playerMusica: AudioStreamPlayer = $AudioStreamPlayer
@onready var timerMusica: Timer = $Timer2
@onready var playerErro: AudioStreamPlayer2D = $Erro

var captadores = []

var posicaoXCaptador: int = -180

var podeInvocarNota: bool = true
var rng = RandomNumberGenerator.new()

var notaAtual: int = 1

var pontuacao: int = 0

var viewportSize: Vector2

@export var bpm: float = 0.0
var secondsPerBeat: float = 60.0 / bpm

const FA:String = "34"
const LA_SUS:String = "32"
const SOL_SUS:String = "37"
const DO_SUS:String = "29"
const MI:String = "28"
const FA_SUS:String = "30"


func _ready() -> void:
	viewportSize = get_viewport_rect().size
	criarCaptadores()
	desempenhoLabel.position.x = viewportSize.x/2 + 220
	desempenhoLabel.position.y = viewportSize.y - 90
	midiPlayer.note.connect(my_note_callback)
	midiPlayer.play()
	timerMusica.start()

func _process(delta: float) -> void:
	pass
	
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

func _on_timer_timeout() -> void:
	#gerarNota()
	pass

func gerarNota(posicaoNota: int) -> void:
	var nota = cenaNota.instantiate()
	var viewportSize2: Vector2 = get_viewport_rect().size
	nota.notaCaiu.connect(_nota_caiu_da_tela)
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

func _captador_clicou_na_nota(area: Area2D, pontos: int, texto: String, cor: Color) -> void:
	area.queue_free()
	pontuacao += pontos
	pontosLabel.text = str(pontuacao).pad_zeros(6)
	desempenhoLabel.text = texto
	desempenhoLabel.add_theme_color_override("font_color", cor)

func _captador_errou_a_nota() -> void:
	_perder_pontos()
	desempenhoLabel.text = "Errou!"
	desempenhoLabel.add_theme_color_override("font_color", Color.RED)
	playerErro.play(1.3)

func _nota_caiu_da_tela() -> void:
	_perder_pontos()
	desempenhoLabel.text = "Errou!"
	desempenhoLabel.add_theme_color_override("font_color", Color.RED)
	
func _perder_pontos() -> void:
	pontuacao -= 5
	if(pontuacao < 0):
		pontuacao = 0
	pontosLabel.text = str(pontuacao).pad_zeros(6)

func my_note_callback(event, track):
	if (event['subtype'] == MIDI_MESSAGE_NOTE_ON): # note on
		match str(event['note']):
			FA:
				gerarNota(1)
			LA_SUS:
				gerarNota(3)
			SOL_SUS:
				gerarNota(2)
			DO_SUS:
				gerarNota(4)
			MI:
				gerarNota(2)
			FA_SUS:
				gerarNota(3)
		print("nota tocada")
	elif (event['subtype'] == MIDI_MESSAGE_NOTE_OFF): # note off
	  # do something on note off
		print("nota soltada")
	print("[Track: " + str(track) + "] Note played: " + str(event['note']))


func _on_timer_2_timeout() -> void:
	playerMusica.play()
