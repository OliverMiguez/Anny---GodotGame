"""
Clase para la conexión de diferentes jugadores
"""
extends Control
var peer = ENetMultiplayerPeer.new()
@export var player_scene =preload("res://Scenes/MainCharacter/main_character.tscn")

@onready var host: Button = $VBoxContainer/Host

func _on_host_pressed() -> void:
	peer.create_server(1025)
	multiplayer.peer_connected.connect(_add_player)
	_add_player()
	host.disabled = true 
	
	
func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child",player)
	 
func _on_join_pressed() -> void:
	peer.create_client("10.0.9.11",1025)
	multiplayer.multiplayer_peer = peer
	
