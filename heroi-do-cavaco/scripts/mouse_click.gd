extends AudioStreamPlayer

func _ready() -> void:
	stream = preload("res://assets/click-234708.mp3")
	volume_db = -15.0

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("click")):
		play()
