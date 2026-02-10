extends CharacterBody2D
class_name MainCharacter

const WALING_SPEED = 150 # Velocidad del player
const JUMP_FORCE = Vector2(260,-400) # Fuerza con la que salta el player 
const RUNNING_SPEED = 250 # Velocidad cuando el player está en el estado de correr
const ROLLING_SPEED = 200 # Velocidad de rodar

const  GRAVITY_VALUE = 1000.0 # Fuerza de gravedad

@onready var main_character_animations: AnimationPlayer = $AnimationPlayer # Animaciones del MainCharacter 
@onready var main_character_collision = $MainCharacterCollision # Colisión del player
@onready var state_machine: Node = $FSM

@onready var jump_sound = $JumpSound # Sonido que hace cuando salta

@onready var plancha_cooldown: Timer = $Plancha_cooldown
var can_jump = true # Para evitar saltar infinitamente

var ammo_packed_scene = preload("res://Scenes/MainCharacter/Ammo/ammo.tscn") # PackedSecne
# Nodo de la bala (para poder instanciar la bala)
var ammo_scene: Ammo 

# Posición en la que spawnea la bala
@onready var ammo_spawn_point = $AmmoSpawnPoint

var can_move = true


@onready var main_charater_idle: Sprite2D = $MainCharaterIdle
@onready var main_character_walk: Sprite2D = $MainCharacterWalk
@onready var main_character_jump: Sprite2D = $MainCharacterJump
@onready var main_character_crouch: Sprite2D = $MainCharacterCrouch
@onready var main_character_roll: Sprite2D = $MainCharacterRoll
@onready var main_character_plancha: Sprite2D = $MainCharacterPlancha



func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

##Función que se ejecuta en cada frame 
func _physics_process(delta):
	if is_multiplayer_authority():
		# Aplica gravedad al player  cuando no este en el suelo
		if not is_on_floor():
			gravity(delta)
		
		state_machine._physics_process(delta)
		
		if can_move:
			handle_movement()
		
		flip_animation() # Gira el sprite del player según su movimiento
		handle_combat()
	move_and_slide() # Permite el movimiento en el player (OBLIGATORIO)


func handle_movement():
	var direction = Input.get_axis("IzquierdaP1","DerechaP1")
	var is_jumping = Input.is_action_just_pressed("ArribaP1")
	
	if is_jumping and is_on_floor():
		velocity.y = JUMP_FORCE.y
	
	if direction != 0:
		var is_running = Input.is_action_pressed("CorrerP1")
		var current_speed = RUNNING_SPEED if is_running else WALING_SPEED
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, WALING_SPEED)
	
## Administra el sistema de combate del player
func handle_combat():
	if Input.is_action_just_pressed("DispararP1"):
		velocity = Vector2.ZERO # Frena en seco al disparar
		instanciate_ammo()
	
##Función que aplica una gravedad al player
func gravity(delta):
	velocity.y = velocity.y +(GRAVITY_VALUE * delta)
	
## Gira el sprite de la animación
func flip_animation():
	if velocity.x > 0:
		#main_character_animations.flip_h = false
		#main_character_collision.position.x = -4.5
		main_charater_idle.flip_h = false
		main_character_walk.flip_h = false
		main_character_jump.flip_h = false
		main_character_crouch.flip_h = false
		main_character_roll.flip_h = false
		main_character_plancha.flip_h = false
	elif velocity.x < 0:
		#main_character_animations.flip_h = true
		#main_character_collision.position.x = 4.5
		main_charater_idle.flip_h = true
		main_character_walk.flip_h = true
		main_character_jump.flip_h = true
		main_character_crouch.flip_h = true
		main_character_roll.flip_h = true
		main_character_plancha.flip_h = true

# Función que llama el estado "Plancha" al terminar
func start_plancha_cooldown():
	can_jump = false # Deshabilita la habilidad
	plancha_cooldown.start()

## Cooldown para la plancha, para evitar errores
func _on_plancha_cooldown_timeout() -> void:
	can_jump = true

## Para hacer referencia del MainCharacter en otros scripts
func MainCharacter():
	pass

## Instancia la bala en pantalla cuando se dispara
func instanciate_ammo():
	# Uso get_parent() para que la bala no herede el movimiento del player
	ammo_scene = ammo_packed_scene.instantiate() # Transforma el PackedScene de la bala a un Node
	get_parent().add_child(ammo_scene) # Añade la escena al árbol de nodos del player
	ammo_scene.global_position = ammo_spawn_point.global_position
	ammo_scene.direction = Vector2.LEFT if main_character_animations.flip_h else Vector2.RIGHT # Modificar el movimiento de la bala
	#print("Posición global de la bala: ",ammo_scene.global_position)
	
	


func _on_door_detection_body_entered(body: Node2D) -> void:
	print("Player entro en el area de una puerta")
