extends "res://Scripts/GeneralStates/Util/State.gd"
@export var idle_state:State
@export var walk_state:State
@export var run_state:State
@export var crouch_state:State
@export var jump_state:State

func on_enter():
	# 1. Reproducir la animación.
	animation_player.play("Plancha")
	
	# 2. Esperar a que la animación termine.
	await animation_player.animation_finished 
	
	# 3. Al terminar el await, ejecutamos la transición final.
	var current_movement: float = father.velocity.x
	
	# Transición a RUN
	if current_movement != 0 and Input.is_action_pressed("Shift"):
		next_state = run_state
		
	# Transición a WALK
	elif current_movement != 0:
		next_state = walk_state
		
	
	if is_instance_valid(father) and "start_plancha_cooldown" in father:
		father.start_plancha_cooldown()


func state_process(_delta: float) -> void:
	# Esta sigue siendo la única interrupción temprana por física.
	if father.velocity.x == 0 and father.is_on_floor():
		next_state = idle_state

func _on_plancha_cooldown_timeout() -> void:
	pass # Replace with function body.







#func on_enter():
	#animation_player.play("Plancha")
	#await animation_player.animation_finished
	#
#
#func state_process(_delta: float) -> void:
	#if father.velocity.x == 0:
		#next_state = idle_state
#
#
#func _on_main_character_animations_animation_finished() -> void:
## Solo cambiamos de estado si terminó la animación de "Plancha"
	#if animation_player.name == "Plancha":
		## La animación terminó. Ahora decidimos a qué estado ir basado en el input actual.
		#var current_movement: float = father.velocity.x
		#
		## Transición a RUN: Aún presiona Shift y se está moviendo.
		#if current_movement != 0 and Input.is_action_pressed("Shift"):
			#next_state = run_state
			#
		## Transición a WALK: Se está moviendo, pero no presiona Shift.
		#elif current_movement != 0:
			#next_state = walk_state
			#
		## Transición a IDLE: No hay movimiento.
		#else:
			#next_state = idle_state
