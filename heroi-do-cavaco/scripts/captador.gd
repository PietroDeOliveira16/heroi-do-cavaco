extends Area2D

class_name Captador

@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

signal clicouNaNota
signal errouANota

var notaDentro: bool = false
var numero: int
var nota: Area2D

const CAPTADOR_CLICADO = preload("res://assets/kenney_board-game-icons/PNG/Default (64px)/timer_100.png")
const CAPTADOR_NORMAL = preload("res://assets/kenney_board-game-icons/PNG/Default (64px)/timer_0.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.texture = CAPTADOR_NORMAL

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("captador_"+str(numero))):
		sprite.texture = CAPTADOR_CLICADO
		timer.start()
		if(has_overlapping_areas()):
			var nota = get_overlapping_areas()[0]
			var diferenca = position.y - nota.position.y
			var pontosGanhos: int = 0
			var textoPontos: String = ""
			var cor: Color
			if(diferenca > -8 && diferenca < 8):
				pontosGanhos = 10
				textoPontos = "Perfeito!"
				cor = Color.GOLD
			elif(diferenca > -18 && diferenca < 18):
				pontosGanhos = 5
				textoPontos = "Bom!"
				cor = Color.GREEN
			elif(diferenca > -28 && diferenca < 28):
				pontosGanhos = 2
				textoPontos = "Ruim"
				cor = Color.LIGHT_CORAL
			else:
				pontosGanhos = 1
				textoPontos = "Horrível..."
				cor = Color.DARK_RED
			clicouNaNota.emit(nota, pontosGanhos, textoPontos, cor)
		else:
			errouANota.emit()

func _on_timer_timeout() -> void:
	sprite.texture = CAPTADOR_NORMAL
