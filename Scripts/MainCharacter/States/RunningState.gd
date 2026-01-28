extends "res://Scripts/GeneralStates/Util/State.gd"

@export var idle_state:State
@export var walk_state:State
@export var jump_state:State
@export var plancha_state:State
@export var shoot_state:State

func on_enter():
	animation_player.play("Run")

func state_process(_delta: float) -> void:
	var direction = Input.get_axis("IzquierdaP1","DerechaP1")
	var is_running = Input.is_action_pressed("CorrerP1")
	
	if is_zero_approx(father.velocity.x):
		next_state = idle_state
		return
	
	if direction != 0 and not is_running:
		next_state = walk_state
		return
	
