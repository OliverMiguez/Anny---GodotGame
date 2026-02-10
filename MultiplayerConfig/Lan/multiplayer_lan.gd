"""
Clase para la conexión de diferentes jugadores
"""
extends Control
var peer = ENetMultiplayerPeer.new()
@export var player_scene =preload("res://Scenes/MainCharacter/main_character.tscn")

@onready var host: Button = $Host

@onready var ip: LineEdit = $IP

@onready var name_input: LineEdit = $NameInput


func _on_host_pressed() -> void:
	var nam = name_input.text.strip_edges()
	if nam == "":
		nam = "Host" # Nombre por defecto si está vacío
	MultiplayerConfig.user_name = nam
	MultiplayerConfig.host_game(1025)
	get_tree().change_scene_to_file("res://Scenes/Multiplayer/Lan Configuration/lobby.tscn")
	
#func _add_player(id = 1):
	#var player = player_scene.instantiate()
	#player.name = str(id)
	#call_deferred("add_child",player)
	 #
func _on_join_pressed() -> void:
	var nam = name_input.text.strip_edges()
	if nam == "":
		nam = "Client" # Nombre por defecto
	MultiplayerConfig.user_name = nam
	MultiplayerConfig.join_game(ip.text, 1025)
	# Esperar un frame y luego cambiar al lobby
	call_deferred("_go_to_lobby")

func _go_to_lobby():
	get_tree().change_scene_to_file("res://Scenes/Multiplayer/Lan Configuration/lobby.tscn")
