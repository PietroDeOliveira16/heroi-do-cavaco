extends Node2D

@onready var kurt = $Sprite2D
@onready var timer = $Timer
@onready var vineBoom = $AudioStreamPlayer2D

func _ready() -> void:
	kurt.self_modulate.a = 0
	kurt.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(kurt, "self_modulate", Color.from_rgba8(255, 255, 255, 255), 0.3)
	vineBoom.play()
	timer.start()

func _on_timer_timeout() -> void:
	var tween2 = get_tree().create_tween()
	tween2.tween_property(kurt, "self_modulate", Color.from_rgba8(255, 255, 255, 0), 0.3)
