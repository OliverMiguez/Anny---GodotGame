extends "res://Scripts/GeneralStates/Util/State.gd"

@export var idle_state:State
@export var walk_state:State
@export var run_state:State
@export var crouch_state:State
@export var jump_state:State
@export var shoot_state:State

func on_enter():
	animation_player.play("Idle")
	
func state_process(_delta: float) -> void:
	var is_running = Input.is_action_pressed("CorrerP1")
	
	# Si la velocidad no es 0
	if not is_zero_approx(father.velocity.x):
		if is_running:
			next_state = run_state
		else:
			next_state = walk_state
		return
		
