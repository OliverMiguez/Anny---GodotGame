extends "res://Scripts/GeneralStates/Util/State.gd"


@export var walk_state:State
@export var jump_state:State
@export var roll_state:State
@export var shoot_state:State

func on_enter():
	animation_player.play("Crouch")

func state_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ShootAction"):
		next_state = shoot_state
	
	elif father.velocity.x != 0 and Input.is_action_just_pressed("ui_down"):
		next_state = roll_state
	
	elif father.velocity.x!=0:
		next_state=walk_state
	
	elif father.velocity.y != 0:
		next_state = jump_state
	
