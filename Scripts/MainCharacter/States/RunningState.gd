extends "res://Scripts/GeneralStates/Util/State.gd"

@export var idle_state:State
@export var walk_state:State
@export var crouch_state:State
@export var jump_state:State

func on_enter():
	animation_player.play("Run")

func state_process(_delta: float) -> void:
	var direction = Input.get_axis("IzquierdaP1","DerechaP1")
	var is_running = Input.is_action_pressed("CorrerP1")
	var is_crouching = Input.is_action_pressed("AbajoP1")

	if not father.is_on_floor():
		next_state = jump_state
		return

	if is_zero_approx(father.velocity.x):
		if is_crouching:
			next_state = crouch_state
			return
		else:
			next_state = idle_state
			return
	
	if direction != 0 and not is_running:
		next_state = walk_state
		return
	
