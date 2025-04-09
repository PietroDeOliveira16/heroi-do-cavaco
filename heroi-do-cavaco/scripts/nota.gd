extends Area2D

class_name Nota

@export var velocidade: float = 0.0
@onready var sprite: Sprite2D = $Sprite2D
signal notaCaiu

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	position.y += velocidade * delta
	if position.y > get_viewport_rect().size.y:
		queue_free()
		notaCaiu.emit()
