extends Node2D

@onready var pontuacaoLabel: Label = $Pontuacao
@onready var sprite: Sprite2D = $Sprite2D2
signal jogarNovamente
signal menu
signal salvarHighscore

func _on_jogar_novamente_pressed() -> void:
	jogarNovamente.emit()

func _on_menu_pressed() -> void:
	menu.emit()
	
func _on_salvar_highscore_pressed() -> void:
	salvarHighscore.emit() # Replace with function body.
