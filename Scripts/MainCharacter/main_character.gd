extends CharacterBody2D
class_name MainCharacter

@export var speed = 100 # Velocidad del player
@export var jump_force = 300 # Fuerza con la que salta el player 
@export var running_speed = 300 # Velocidad cuando el player está en el estado de correr

const  GRAVITY_VALUE = 980.0 # Fuerza de gravedad

@onready var main_character_animations = $MainCharacterAnimations # Animaciones del MainCharacter 

@onready var jump_sound = $JumpSound # Sonido que hace cuando salta

##Función que se ejecuta en cada frame 
func _physics_process(delta):
	# Aplica gravedad al player  cuando no este en el suelo
	if not is_on_floor():
		gravity(delta)
		 
	move_and_slide() # Permite el movimiento en el player (OBLIGATORIO)

## Movimientos del player
func _input(_event: InputEvent) -> void:
	# Correr a la izquierda
	if Input.is_action_pressed("ui_left") and Input.is_action_pressed("Shift"):
		velocity.x =-running_speed
	
	# Correr a la derecha
	elif Input.is_action_pressed("ui_right") and Input.is_action_pressed("Shift"):
		velocity.x =running_speed
	
	# Andar a la derecha
	elif Input.is_action_pressed("ui_right"):
		velocity.x=100
	
	# Andar a la izquierda
	elif Input.is_action_pressed("ui_left"):
		velocity.x=-100   
	
	# Agacharse
	elif Input.is_action_pressed("ui_down"):
		velocity.x = 0
		
	# Saltar
	elif Input.is_action_pressed("ui_up"):
		velocity.y = -jump_force
		
	# Importante para frenar al player y que no camine infinitamente
	else:
		velocity.x = 0
##Función que aplica una gravedad al player
func gravity(delta):
	velocity.y = velocity.y +(GRAVITY_VALUE * delta)
