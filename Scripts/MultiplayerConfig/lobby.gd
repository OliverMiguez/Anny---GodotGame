extends Control
class_name Lobby

@onready var players_box: VBoxContainer = $players_box
@onready var start_button: Button = $start_button

func _ready():
	MultiplayerConfig.players_updated.connect(update_players)
	start_button.visible = multiplayer.is_server()

	if !multiplayer.is_server():
		multiplayer.connected_to_server.connect(_register_name)

	update_players()

func _register_name():
	MultiplayerConfig.rpc_id(1, "register_player", MultiplayerConfig.user_name)

func update_players():
	for child in players_box.get_children():
		child.queue_free()

	for id in MultiplayerConfig.players:
		var label = Label.new()
		label.text = MultiplayerConfig.players[id]
		players_box.add_child(label)

func _on_start_button_pressed() -> void:
	MultiplayerConfig.rpc("start_game")
