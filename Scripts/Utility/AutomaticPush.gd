"""
Permite hacer push automaticos al repositorio
"""
extends Node
class_name Automatic_Push

# Variables que hacen referencia al boton y al textEdit
@onready var button: Button = $Button
@onready var text_edit: TextEdit = $TextEdit

var commit_text:String = "" # Nombre del commit

func _ready() -> void:
	_load_secrets("res://Config/config_secrets.cfg")


func _load_secrets(path):
	var file = File.new()
	if file.file_exist(path):
		file.open(path,File.READ)
		while not file.eof_reached():
			var line = file.get_line().strip_edges()
			if line == "" or line.begins_with("#"):
				continue
			var parts = line.split("=")
			if parts.size() == 2:
				secrets[parts[0].strip_edges()] = parts[1].strip_edges()
		file.close()
	else:
		push_error("Archivo de secretos no encontrado: " + path)

func _git_add_commit_push(commit_message):
	var token = secrets.get("GITHUB_TOKEN", "")
	var user = secrets.get("GITHUB_USER", "")
	var repo = secrets.get("GITHUB_REPO", "")

	if token == "" or user == "" or repo == "":
		push_error("Faltan datos en el archivo de secretos")
		return

	# Comandos de Git
	var add_cmd = "git add ."
	var commit_cmd = 'git commit -m "' + commit_message + '"'
	var push_cmd = 'git push https://' + token + '@github.com/' + user + '/' + repo + '.git HEAD'

	# Ejecutar comandos
	_run_command(add_cmd)
	_run_command(commit_cmd)
	_run_command(push_cmd)

func _run_command(cmd):
	var result = OS.execute("bash", ["-c", cmd], true)
	if result != 0:
		push_error("Error ejecutando comando: " + cmd)
	else:
		print("Comando ejecutado: " + cmd)
		
	

## Recoge el nombre del commit
func _on_button_pressed() -> void:
	commit_text = text_edit.text # Recoge el valor del textEdit
	if commit_text == "": # Evitar valores nulos
		commit_text = "Mensaje de commit por defecto"
		print("Mensaje del commit :"+ commit_text)
	else:
			print("Mensaje del commit :"+ commit_text)
# Reinicia los valores
	commit_text = ""
	text_edit.text = ""
	
