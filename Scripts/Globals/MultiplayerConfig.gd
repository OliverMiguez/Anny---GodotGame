extends Node

# ENet Multiplayer Peer
var peer: ENetMultiplayerPeer
var user_name: String = ""

# Diccionario de jugadores conectados: id -> nombre
var players := {} 

# Señal para actualizar el lobby cuando cambian los jugadores
signal players_updated

# -----------------------------
# Host
# -----------------------------
func host_game(port := 1025):
	peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer

	# Conectamos señales para manejar peers conectados/desconectados
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

	# El host se registra a sí mismo
	var my_id = multiplayer.get_unique_id()
	players[my_id] = user_name
	players_updated.emit()


# -----------------------------
# Cliente
# -----------------------------
func join_game(ip: String, port := 1025):
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer


# -----------------------------
# Señales de multiplayer
# -----------------------------
func _on_peer_connected(id):
	if multiplayer.is_server():
		# Cuando un cliente se conecta, enviamos la lista completa
		rpc_id(id, "sync_players", players)

func _on_peer_disconnected(id):
	players.erase(id)
	players_updated.emit()
	# Opcional: informar a todos los clientes que cambió la lista
	rpc("sync_players", players)


# -----------------------------
# RPCs
# -----------------------------

# Sincroniza la lista de jugadores a todos los peers
@rpc("any_peer") # cualquier peer puede recibirla
func sync_players(server_players: Dictionary):
	players = server_players
	players_updated.emit()

# Registrar un nuevo jugador en el host
@rpc("any_peer")
func register_player(name: String):
	var id = multiplayer.get_remote_sender_id()
	players[id] = name
	players_updated.emit()

	# ¡Muy importante! sincronizamos con todos los clientes
	rpc("sync_players", players)

# Iniciar juego (lo ejecuta el host)
@rpc("any_peer")
func start_game():
	get_tree().change_scene_to_file("res://Scenes/Test/mapa_prueba.tscn")
