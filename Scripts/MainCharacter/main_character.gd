extends CharacterBody2D
class_name MainCharacter

@export var speed = 100 # Velocidad del player
@export var jump_force = 300 # Fuerza con la que salta el player 
@export var running_speed = 300 # Velocidad cuando el player está en el estado de correr

const  GRAVITY_VALUE = 980.0 # Fuerza de gravedad

@onready var main_character_animations = $MainCharacterAnimations # Animaciones del MainCharacter 
@onready var main_character_collision = $MainCharacterCollision # Colisión del player

@onready var jump_sound = $JumpSound # Sonido que hace cuando salta

var can_jump = true # Para evitar saltar infinitamente


##Función que se ejecuta en cada frame 
func _physics_process(delta):
	# Aplica gravedad al player  cuando no este en el suelo
	if not is_on_floor():
		gravity(delta)
		
	flip_animation()
	move_and_slide() # Permite el movimiento en el player (OBLIGATORIO)

## Movimientos del player
func _input(event: InputEvent) -> void:
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
		
	# Importante para frenar al player y que no camine infinitamente
	else:
		velocity.x = 0
	
	# Saltar
	if is_on_floor and event.is_action("ui_up") and can_jump:
		velocity.y = -jump_force
		#main_character_collision.position.y = -2
		can_jump = false

	else:
		if velocity.y == 0:
			#main_character_collision.position.y = 5
			can_jump = true
			
##Función que aplica una gravedad al player
func gravity(delta):
	velocity.y = velocity.y +(GRAVITY_VALUE * delta)
	
	
	
## Gira el sprite de la animación
func flip_animation():
	var direction = Input.get_axis("ui_left","ui_right")

	if direction > 0:
		main_character_animations.flip_h = false
		main_character_collision.position.x = -4.5
	elif direction < 0:
		main_character_animations.flip_h = true
		main_character_collision.position.x = 4.5


	
