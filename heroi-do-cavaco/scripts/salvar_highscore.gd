

extends Node2D

@onready var labelTeste = $LabelPontuacao
@onready var labelStatusSalvarArquivo: Label = $LabelStatus
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
	if(nome.is_empty() || escola.is_empty()):
		erroAoSalvar()
	else:
		var file = FileAccess.open("user://leaderboard/"+nomeFormatado+".txt", FileAccess.WRITE)
		var isFiledSaved = file.store_string("Nome: " + nome + "; Escola: "+ escola + "; Pontuacao: " + str(pontuacao))
		if(isFiledSaved):
			labelStatusSalvarArquivo.add_theme_color_override("font_color", Color.GREEN)
			labelStatusSalvarArquivo.text = 'Arquivo salvo com sucesso!'
			labelStatusSalvarArquivo.visible = true
			print("Arquivo criado em " + ProjectSettings.globalize_path(file.get_path()))
			file.close()
		else:
			erroAoSalvar()
			file.close()

func erroAoSalvar():
		labelStatusSalvarArquivo.add_theme_color_override("font_color", Color.RED)
		labelStatusSalvarArquivo.text = 'Erro ao salvar arquivo :('
		labelStatusSalvarArquivo.visible = true

func _on_cancelar_pressed() -> void:
	voltarMenu.emit()
