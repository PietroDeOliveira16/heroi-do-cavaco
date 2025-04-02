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

var captadores = []

var posicaoXCaptador: int = -180

var podeInvocarNota: bool = true
var rng = RandomNumberGenerator.new()

var notaAtual: int = 1

var pontuacao: int = 0

var viewportSize: Vector2

func _ready() -> void:
	viewportSize = get_viewport_rect().size
	criarCaptadores()
	desempenhoLabel.position.x = viewportSize.x/2 + 220
	desempenhoLabel.position.y = viewportSize.y - 90

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
	gerarNota()

func gerarNota() -> void:
	var nota = cenaNota.instantiate()
	var viewportSize2: Vector2 = get_viewport_rect().size
	add_child(nota)
	if(notaAtual == 1):
		nota.sprite.texture = img_nota1
		nota.position.x = viewportSize2.x/2 - 180
	elif(notaAtual == 2):
		nota.sprite.texture = img_nota2
		nota.position.x = viewportSize2.x/2 - 80
	elif(notaAtual == 3):
		nota.sprite.texture = img_nota3
		nota.position.x = viewportSize2.x/2 + 20
	else:
		nota.sprite.texture = img_nota4
		nota.position.x = viewportSize2.x/2 + 120
		notaAtual = 0
	notaAtual += 1

func _captador_clicou_na_nota(area: Area2D, pontos: int, texto: String, cor: Color) -> void:
	area.queue_free()
	pontuacao += pontos
	pontosLabel.text = str(pontuacao).pad_zeros(6)
	desempenhoLabel.text = texto
	desempenhoLabel.add_theme_color_override("font_color", cor)

func _captador_errou_a_nota() -> void:
	pontuacao -= 5
	if(pontuacao < 0):
		pontuacao = 0
	pontosLabel.text = str(pontuacao).pad_zeros(6)
	desempenhoLabel.text = "Errou!"
	desempenhoLabel.add_theme_color_override("font_color", Color.RED)
