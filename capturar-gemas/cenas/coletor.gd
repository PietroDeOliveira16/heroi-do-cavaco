extends Area2D

@export var velocidade: float = 400.0
signal gema_capturada

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var quantidade_input: float = Input.get_axis("esquerda", "direita")
	position.x += velocidade * delta * quantidade_input


func _on_area_entered(area: Area2D) -> void:
	gema_capturada.emit(area)
