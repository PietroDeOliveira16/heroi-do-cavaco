extends Node2D

signal comecarJogo

func _on_button_pressed() -> void:
	comecarJogo.emit()
