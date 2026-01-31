extends Node2D
@onready var prueba_musica = $MusicTest

# Markers para las puertas del mapa
@onready var area_2d: Area2D = $Doors/Area2D

@onready var door_1_left_down: Marker2D = $Doors/Markers/Marker1LeftDown
@onready var door_2_left_up: Marker2D = $Doors/Markers/Marker2LeftUp
@onready var door_3_right_up: Marker2D = $Doors/Markers/Marker3RightUp
@onready var door_4_right_down: Marker2D = $Doors/Markers/Marker4RightDown

# Puntos de spawn (donde spawnearan los objetos)
@onready var spawn_1 = $SpawnPoints/Spawn1
@onready var spawn_2 = $SpawnPoints/Spawn2
@onready var spawn_3 = $SpawnPoints/Spawn3


# Array que recoge los puntos de spawneo (para escoger uno aleatoriamente)
# Sin @onready, este array se inicializa antes de que las variables spawn_X
# hayan sido asignadas, por lo que su valor en ese momento es null.
# Al usar @onready, forzamos a que el array se construya cuando el nodo
# ya está en el árbol y las referencias spawn_1, spawn_2 y spawn_3
# ya contienen los Marker2D correctos.
@onready var almacen_spawners =[spawn_1.position, spawn_2.position, spawn_3.position]

# Variable para administrar el control de rondas
var ronda_actual = 1

# Precargamos un objeto para ver el funcionamiento del spawneo aleatorio controlado(DEBUG)
# Para spawnear un objeto en x punto del mapa que yo quiera aleatoriamente(Marker2d)
var box_packed_scene = preload("res://Scenes/Objects/Box/box.tscn") # No es un nodo, es un PackedScene

# Valor aleatorio en el que spawneará el objeto o enemigo
var valor_spawneo_obtenido = 0

#(DEBUG)
# Label que muestra la ronda actual 
@onready var ronda_actual_label = $DEBUG/RondaActual
# Botones que permiten matar al player o a los enemigos
@onready var death_button_player = $DEBUG/DeathButtonPlayer
@onready var death_button_enemy = $DEBUG/DeathButtonEnemy
@onready var pos_player: Label = $DEBUG/PosPlayer


func _ready():
	prueba_musica.play() # Inicia la musica
	start_round() # Inicia la ronda

	
	# Señal que recibe si el enemigo o enemigos mueren(para aumentar ronda)
	RoundManager.cambio_ronda.connect(_on_RoundManager_cambio_ronda) # deprecada
	
# En cada frame del juego
func _physics_process(_delta):
	ronda_actual_label.text = str(ronda_actual) # Muestra en el label la ronda actual
	pos_player.text = str($MainCharacter.position)

func _on_prueba_musica_finished():
	prueba_musica.play()
	
## Selecciona una posición ramdon en la que spawneará un enemigo
func randomSpawn():
	var tamaño_almacen_spawners = almacen_spawners.size()
	var indice_valor_obtenido_spawn = randi() % tamaño_almacen_spawners # El indice del array obtenido aleatoriamente
	valor_spawneo_obtenido = almacen_spawners[indice_valor_obtenido_spawn]
	instantiateBoxInMap() # Permite instanciar un objeto(en este caso una caja)


## Permite instanciar la caja en el mapa en la posición deseada
func instantiateBoxInMap():
	 # Combierte el packedScene(box_packed_scene) en un nodo con el que podremos modificar su posición
	var box_instancia = box_packed_scene.instantiate()
	add_child(box_instancia) # Añade la instancia a la escena
	box_instancia.add_to_group("spawned")
	box_instancia.position = valor_spawneo_obtenido

## Limpia los objetos instanciados de la escena
func clear_spawned():
	for obj in get_tree().get_nodes_in_group("spawned"):
		obj.queue_free()
	
		

				
## Reinicia la ronda a 1
func start_round():
	ronda_actual = 1
	clear_spawned() # Elimina los objetos que se instanciaron en rondas anteriores
	randomSpawn() # Permite spawnear aleatoriamente controlado los objetos por el mapa( de momento una caja)

	
## Si este botón se presiona mata al player (DEBUG)
func _on_death_button_pressed():
	print("El player a muerto")
	start_round() # Reinicia las rondas del juego
## Simula la muerte de un enemigo inexistente o mata a los enemigos que existan (DEBUG)
func _on_death_button_enemy_pressed():
	print("Todos los enemigos han muerto")
	# Mostrariamos una ventana de victoria
	ronda_actual += 1 # Aumenta de ronda si se matan a todos los enemigos
	## Resetea la scena
func _on_reset_scene_pressed():
	get_tree().reload_current_scene()

## Cambia de ronda cuando todos los enemigos de la ronda mueren
## Deprecada
func _on_RoundManager_cambio_ronda(_valor):
	pass
	
func cambiar_ronda():
		ronda_actual += 1

		
func victoria():
	print("Superaste 10 rondas ")
	if ronda_actual == 11:
		ronda_actual = str("Victoria")

## Puertas
func _on_left_door_up_body_entered(body: Node2D) -> void:
	body.position = door_1_left_down.position
	
func _on_right_door_down_body_entered(body: Node2D) -> void:
	body.position = door_3_right_up.position

func _on_right_door_up_body_entered(body: Node2D) -> void:
	body.position = door_4_right_down.position

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.position = door_2_left_up.position
