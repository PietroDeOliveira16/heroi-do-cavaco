extends Node2D

signal comecarJogo

@onready var button = $Button

func _ready() -> void:
	button.grab_focus()

func _on_button_pressed() -> void:
	comecarJogo.emit()
