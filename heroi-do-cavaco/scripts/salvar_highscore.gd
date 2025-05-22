extends Node2D

@onready var labelTeste = $LabelPontuacao
@onready var nomeTextBox = $Nome
@onready var escolaTextBox = $Escola

signal voltarMenu

var nome = ""
var escola = ""
var pontuacao = 0

func _on_salvar_highscore_pressed() -> void:
	nome = nomeTextBox.text
	escola = escolaTextBox.text
	var caracteres_para_remover = [" ", "\t", "\n"]
	for c in caracteres_para_remover:
		nome = nome.replace(c, "")
		escola = escola.replace(c, "")
	var nomeFormatado = nome.to_upper()
	pontuacao = int(labelTeste.text)
	print(nome + "; ", escola + "; ", pontuacao)
	var file = FileAccess.open("user://leaderboard/"+nomeFormatado+".txt", FileAccess.WRITE)
	file.store_string("Nome: " + nome + "; Escola: "+ escola + "; Pontuacao: " + str(pontuacao))
	print("Arquivo criado em " + ProjectSettings.globalize_path(file.get_path()))
	file.close()


func _on_cancelar_pressed() -> void:
	voltarMenu.emit()
