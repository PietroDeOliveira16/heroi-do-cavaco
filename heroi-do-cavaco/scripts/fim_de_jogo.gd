extends Node2D

@onready var pontuacaoLabel: Label = $Pontuacao
@onready var sprite: Sprite2D = $Sprite2D2
signal jogarNovamente
signal menu

func _on_jogar_novamente_pressed() -> void:
	jogarNovamente.emit()


func _on_menu_pressed() -> void:
	menu.emit()
