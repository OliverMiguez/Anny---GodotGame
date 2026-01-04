extends Node2D
@onready var prueba_musica = $MusicTest

# Markers para las puertas del mapa
@onready var marker_1_left_down: Marker2D = $Doors/Markers/Marker1LeftDown
@onready var marker_2_left_up: Marker2D = $Doors/Markers/Marker2LeftUp
@onready var marker_3_right_up: Marker2D = $Doors/Markers/Marker3RightUp
@onready var marker_4_right_down: Marker2D = $Doors/Markers/Marker4RightDown

# Puntos de spawn (donde spawnearan los enemigos)
@onready var spawn_1 = $SpawnPoints/Spawn1
@onready var spawn_2 = $SpawnPoints/Spawn2
@onready var spawn_3 = $SpawnPoints/Spawn3


# Array que recoge los puntos de spawneo (para escoger uno aleatoriamente)
var almacen_spawners:Array =[spawn_1, spawn_2, spawn_3]

# Variable para administrar el control de rondas
var ronda_actual = 1

#(DEBUG)
# Label que muestra la ronda actual 
@onready var ronda_actual_label = $DEBUG/RondaActual
# Botones que permiten matar al player o a los enemigos
@onready var death_button_player = $DEBUG/DeathButtonPlayer
@onready var death_button_enemy = $DEBUG/DeathButtonEnemy


func _ready():
	#var punto1 = spawn_1.position
	#print(punto1)
	print("Almacen_spawners: ", almacen_spawners)

	prueba_musica.play()
	print("Prueba: Entro en el mapa")
	randomSpawn() # Obtiene una posición de spawneo aleatoria

# En cada frame del juego
func _physics_process(_delta):
	ronda_actual_label.text = str(ronda_actual) # Muestra en el label la ronda actual

func _on_prueba_musica_finished():
	prueba_musica.play()
	
## Selecciona una posición ramdon en la que spawneará un enemigo
func randomSpawn():
	var tamaño_almacen_spawners = almacen_spawners.size()
	var indice_valor_obtenido_spawn = randi() % tamaño_almacen_spawners # El indice del array obtenido aleatoriamente
	print("Indice obtenido: ", indice_valor_obtenido_spawn)
	print("Posición obtenida: ", almacen_spawners[indice_valor_obtenido_spawn])

## Puertas 
# Puerta de abajo
func _on_left_door_down_body_entered(body: Node2D) -> void:
	print("Prueba: Algo entro en el area")
	if body is MainCharacter:
		print("ENTRO EL MAINCHARACTER")
		if Input.is_action_just_pressed("Space"):
			MainCharacter.position = marker_2_left_up.position

func _on_left_door_down_body_exited(body: Node2D) -> void:
	print("Prueba: Algo salió del area")
	if body is MainCharacter:
		print("SALIO EL MAINCHARACTER")

## Si este botón se presiona mata al player (DEBUG)
func _on_death_button_pressed():
	print("El player a muerto")
	# Mostrariamos ademas la ventana de derrota
	ronda_actual = 1

## Simula la muerte de un enemigo inexistente o mata a los enemigos que existan (DEBUG)
func _on_death_button_enemy_pressed():
	print("Todos los enemigos han muerto")
	# Mostrariamos una ventana de victoria
	ronda_actual += 1 # Aumenta de ronda si se matan a todos los enemigos
