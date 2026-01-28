extends "res://Scripts/GeneralStates/Util/State.gd"

@export var idle_state:State
@export var run_state:State
@export var jump_state:State
@export var roll_state:State
@export var shoot_state:State

func on_enter():
	animation_player.play("Walk")

func state_process(_delta: float) -> void:
	var is_running = Input.is_action_pressed("CorrerP1")
	
	if is_zero_approx(father.velocity.x):
		next_state = idle_state
		return
	
	if is_running:
		next_state = run_state
		return
