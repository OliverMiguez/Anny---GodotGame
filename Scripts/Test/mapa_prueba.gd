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

# Puntos de spawn (donde spawnean los enemigos)
@onready var enemy_spawn_1 = $EnemySpawnPoints/EnemySpawn1
@onready var enemy_spawn_2 = $EnemySpawnPoints/EnemySpawn2
@onready var enemy_spawn_3 = $EnemySpawnPoints/EnemySpawn3
@onready var enemy_spawn_4 = $EnemySpawnPoints/EnemySpawn4
@onready var enemy_spawn_5 = $EnemySpawnPoints/EnemySpawn5

# Recoge la escena del enemigo en un PackedScene
var packed_scene_enemy = preload("res://Scenes/Enemys/Test/enemy.tscn")
# Recoge las posiciones de donde podrán spawnear los enemigos
@onready var almacen_spawners_enemys = [
	enemy_spawn_1.position,
	enemy_spawn_2.position,
	enemy_spawn_3.position,
	enemy_spawn_4.position,
	enemy_spawn_5.position
	]

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
var valor_spawneo_obtenido_enemigo = 0 

# Las rondas en la que espawnearan los nuevos enemigos
var rounds_to_add_enemy = [3,5,7,9]
# Para poder cambia de ronda cuando mueren todos los enemigos
var enemy_counter = 0 # Para ver cuantos enemigos hay en la ronda actual, para poder cambiar de ronda cuando mueran todos

var enemy_array =[] # Recoge los enemigo instanciados

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
	#print("Pos colision: ", $Doors/LeftDoorDown/CollisionShape2D.position)
	
	#door_1_left_down.position = Vector2(128,940)
	#door_2_left_up.position = Vector2(87,221)
	#door_3_right_up.position = Vector2()
	
	# Señal que recibe si el enemigo o enemigos mueren(para aumentar ronda)
	RoundManager.cambio_ronda.connect(_on_RoundManager_cambio_ronda) # deprecada
	RoundManager.enemigo_murio.connect(_on_RoundManager_enemigo_murio)
	
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

func randomSpawnEnemy(array_axuliar:Array):
	var enemy_position_almacen = array_axuliar.size()
	if enemy_position_almacen != 0:
		var valor_de_posicion_obtenido = randi() %  enemy_position_almacen
		valor_spawneo_obtenido_enemigo = array_axuliar[valor_de_posicion_obtenido]
	else:
		print("Es cero")

	
## Permite instanciar la caja en el mapa en la posición deseada
func instantiateBoxInMap():
	 # Combierte el packedScene(box_packed_scene) en un nodo con el que podremos modificar su posición
	var box_instancia = box_packed_scene.instantiate()
	add_child(box_instancia) # Añade la instancia a la escena
	box_instancia.add_to_group("spawned")
	box_instancia.position = valor_spawneo_obtenido

## Limpia los objetos instanciados de la escena
func clear_spawned():
	enemy_counter = 0
	print("Enemigos actuales: ", enemy_counter)
	for obj in get_tree().get_nodes_in_group("spawned"):
		obj.queue_free()
		
## Limpia los enemigos de la escena
func clear_spawned_enemys():
	enemy_counter = 0
	print("Enemigos actuales: ", enemy_counter)
	for obj in get_tree().get_nodes_in_group("spawned_enemys"):
		obj.queue_free()
		
## Permite añadir más enemigos (cuando se superen x rondas)
func add_more_enemys():
	var number_enemies = 0 # Cantidad de enemigos que spawnearan en la ronda
	print("Ronda actual: ", ronda_actual)

	# Administra la cantidad de enemigos por ronda
	if ronda_actual == 1 or ronda_actual == 2:
		number_enemies = 1
	elif ronda_actual == 3 or ronda_actual == 4:
		number_enemies = 2
	elif ronda_actual == 5 or ronda_actual == 6:
		number_enemies = 3
	elif ronda_actual == 7 or ronda_actual == 8:
		number_enemies = 4
	elif ronda_actual == 9 or ronda_actual == 10:
		number_enemies = 5
	elif ronda_actual > 10:
		victoria()
	else:
		number_enemies = 0
	
	# Detecta las posiciones del spawn que estan libres para spawnear enemigos
	var auxiliar_spawn = [
	enemy_spawn_1.position,
	enemy_spawn_2.position,
	enemy_spawn_3.position,
	enemy_spawn_4.position,
	enemy_spawn_5.position
	]	   
	# Añade a lo enemigos
	for i in range(number_enemies):
		
		# Crea y añade la instancia del enemigo a la escena
		var new_enemy_instance = packed_scene_enemy.instantiate()
		add_child(new_enemy_instance)
		
		 # Añade el enemigo en el array que maneja los enemigos
		enemy_array.append(new_enemy_instance)
		
		# Modifica la posición en la que spawnea
		new_enemy_instance.position = valor_spawneo_obtenido_enemigo
		print("Valor spawneo obtenido enemigo:" , valor_spawneo_obtenido_enemigo)
		new_enemy_instance.add_to_group("spawned_enemys")
		
		# Debug(verificar cuantos enemigos hay en escena)
		enemy_counter += 1
		print("Enemigos en el mapa: ",enemy_counter)
		
		# Administra un spawneo controlado para que 2 enemigos no puedan spawnear en el mismo sitio
		auxiliar_spawn.erase(valor_spawneo_obtenido_enemigo)
		randomSpawnEnemy(auxiliar_spawn)
				
## Reinicia la ronda a 1
func start_round():
	ronda_actual = 1
	clear_spawned() # Elimina los objetos que se instanciaron en rondas anteriores
	randomSpawn() # Permite spawnear aleatoriamente controlado los objetos por el mapa( de momento una caja)
	randomSpawnEnemy(almacen_spawners_enemys) # Permite coger una posición aleatoria donde spawnear el enemigo
	add_more_enemys()
	
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
		randomSpawnEnemy(almacen_spawners_enemys)
		ronda_actual += 1
		add_more_enemys()

## Cuando un enemigo muere
func _on_RoundManager_enemigo_murio(id_enemy):
	enemy_array.erase(id_enemy)# Elimina del array al enemigo que murio
	id_enemy.queue_free()
	if enemy_array.is_empty():
		cambiar_ronda()
		
func victoria():
	print("Superaste 10 rondas ")
	if ronda_actual == 11:
		ronda_actual = str("Victoria")




 

func _on_left_door_up_body_entered(body: Node2D) -> void:
	body.position = Vector2(378,888)
func _on_right_door_down_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_right_door_up_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass
