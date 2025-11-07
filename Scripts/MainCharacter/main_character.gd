extends CharacterBody2D
class_name MainCharacter

 # Estados del MainCharacter
enum main_character_states {IDLE,WALKING,HITTING,SHOOTING,RUNNING,TAKINGGUN,ROLLING,JUMPING,FALLING,CROUCHING,TAKINGDAMAGE,DEAD}
var current_state = main_character_states.IDLE # Estado inicial

@export var speed = 100 # Velocidad del player
@export var jump_force = 300 # Fuerza con la que salta el player 
@export var running_speed = 160 # Velocidad cuando el player está en el estado de correr
@export var speed_null = 0 # Para administrar la velocidad del player por ejemplo cuando se agacha, para evitar que se mueva
const  GRAVITY_VALUE = 980.0 # Fuerza de gravedad

@onready var main_character_animations = $MainCharacterAnimations # Animaciones del MainCharacter 

@onready var jump_sound = $JumpSound # Sonido que hace cuando salta



## Se ejecuta en cada frame 
func _physics_process(delta):
	if not is_on_floor(): # Aplica gravedad al player  cuando no este en el suelo
		gravity(delta) 

	# Máquina de estados main-character
	match  current_state:
		#Estado IDLE
		main_character_states.IDLE:
			player_movement()
			if not is_on_floor(): # FALLING
				current_state = main_character_states.FALLING
			if Input.is_action_just_pressed("Up_Input") and is_on_floor(): # JUMPING
				current_state = main_character_states.JUMPING
				jump()
			elif Input.is_action_pressed("Down_Input") and is_on_floor(): # CROUCHING
				current_state = main_character_states.CROUCHING
				crouch_no_velocity() # Hasta que no cambie de estado, lo mantiene quieto agachado
			elif Input.is_action_pressed("Shift") and velocity.x != 0: # RUNNING
				enter_run() # Cambia la velocidad a la velocidad de carrera
				current_state = main_character_states.RUNNING
			elif velocity.x > 0 || velocity.x < 0:
				current_state = main_character_states.WALKING # WALKING
			else:
				current_state = main_character_states.IDLE # IDLE
				

		# Estado Walking
		main_character_states.WALKING:
			player_movement()
			if not is_on_floor():
				current_state = main_character_states.FALLING # FALLING
			else:
				if velocity.x == 0:
					current_state = main_character_states.IDLE # IDLE
				elif Input.is_action_just_pressed("Up_Input") and is_on_floor(): # JUMPING
					current_state = main_character_states.JUMPING
					jump()
				elif Input.is_action_pressed("Shift") and velocity.x != 0: # RUNNING
					enter_run()
					current_state = main_character_states.RUNNING
				elif Input.is_action_pressed("Down_Input") and velocity.x == 0: # CROUCHING
					current_state = main_character_states.CROUCHING
					crouch_no_velocity()
				else:
					current_state = main_character_states.WALKING # WALKING
					

		main_character_states.CROUCHING:
					# El jugador PERMANECE en este estado mientras Down_Input esté presionado.
					if not Input.is_action_pressed("Down_Input") and is_on_floor():
						# 1. Restaura la velocidad (variable speed, aunque player_movement la usará)
						crouch_velocity() 
						
						# 2. Decide si ir a IDLE o WALKING. Como velocity.x aún está en 0
						#    al salir del estado, comprobamos si hay input de movimiento.
						var direction := Input.get_action_strength("Right_Input") - Input.get_action_strength("Left_Input")
						
						if direction != 0:
							current_state = main_character_states.WALKING
						else:
							current_state = main_character_states.IDLE
					# Si Down_Input sigue presionado, no hacemos nada más, 
					# y player_movement() mantendrá la velocidad en 0.
		#Estado Hitting
		main_character_states.HITTING:
			punch()
			
		# Estado Shooting
		main_character_states.SHOOTING:
			shoot()
		
		# Estado Running
		main_character_states.RUNNING:
			if not is_on_floor():
				exit_run()
				current_state = main_character_states.FALLING # Falling
			elif velocity.x == 0:
				exit_run()
				current_state = main_character_states.IDLE # IDLE
			elif Input.is_action_just_pressed("Up_Input") and is_on_floor():
				exit_run()
				current_state = main_character_states.JUMPING # JUMPING
				jump()
			elif velocity.x != 0:
				exit_run()
				current_state = main_character_states.WALKING # WALKING
			elif Input.is_action_pressed("Down_Input") and is_on_floor():
				exit_run()
				current_state = main_character_states.CROUCHING # CROUCHING
			
		# Estado TakingGun
		main_character_states.TAKINGGUN:
			take_gun()
			
		# Estado Rolling
		main_character_states.ROLLING:
			roll()

		# Estado Jumping
		main_character_states.JUMPING:
			if velocity.y > 0: # Cuando empieza a caer (la velocidad Y es positiva)
				current_state = main_character_states.FALLING

		# Estado Falling
		main_character_states.FALLING:
			if is_on_floor():
				if velocity.x == 0:
					current_state = main_character_states.IDLE
					crouch_velocity() # Devuelve el movimiento al player tras cambiar de estado
				elif velocity.x > 0 ||velocity.x < 0 :
					current_state = main_character_states.WALKING
					crouch_velocity()
		
		# Estado TakingDamage
		main_character_states.TAKINGDAMAGE:
			pass
		
		# Estado Dead
		main_character_states.DEAD:
			pass


	player_animations() # Llama a la función que permite el ejecutar la animaciones del player 


### Métodos de la máquina de estados
## Estado reposo
func idle():
	print("En el estado Idle")
	pass
## Estado caminando
func walk():
	print("En el estado Walk")
	pass
func punch():
	pass
func shoot():
	pass
	
# Cambia la velocidad, a la velocidad de aceleración
func enter_run():
	speed = running_speed
	
# Restablece la velocidad cuando no corre
func exit_run():
	speed = 100

func take_gun():
	pass
func roll():
	pass

# Estado agacharse, permite cubrirse de peligros, mantiene al player quieto
func crouch_no_velocity():
	velocity.x = speed_null # evita que el player se mueva cuando esta agachado

# Devuelve la velocidad al player cuando deja de estar agachado
func crouch_velocity():
	velocity.x = speed

## Estado saltando
func jump():
	jump_sound.play()
	velocity.y -= jump_force

## Estado callendo
# Aplica una gravedad
func fall():
	if is_on_floor: 
		current_state = main_character_states.IDLE


## Otros métodos
# Se ejecuta cuando se detecta un Input del teclado para mover al main-character
func player_movement():
	# Evita mover al player cuando está agachado
	if current_state == main_character_states.CROUCHING:
		velocity.x = 0
	else:
		# Movimiento horizontal
		var direction := Input.get_action_strength("Right_Input") - Input.get_action_strength("Left_Input")
		velocity.x = direction * speed
	
	# Mover al personaje
	move_and_slide()

## Animaciones del player
func player_animations():
	if current_state == main_character_states.JUMPING or current_state == main_character_states.FALLING:
		main_character_animations.play("Jump")
		
	if velocity.x > 0: 
		main_character_animations.play("Walk")
		main_character_animations.flip_h = false
	elif velocity.x < 0: 
		main_character_animations.play("Walk")
		main_character_animations.flip_h = true
	elif velocity.x == 0 and is_on_floor(): 
		main_character_animations.play("Idle")
		
	if Input.is_action_pressed("Down_Input"):
		main_character_animations.play("Crouch")
		
## Gravedad que afecta al player 
func gravity(delta):
	velocity.y = velocity.y +(GRAVITY_VALUE * delta)
