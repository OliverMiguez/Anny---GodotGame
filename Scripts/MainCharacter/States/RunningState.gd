extends "res://Scripts/GeneralStates/Util/State.gd"

@export var idle_state:State
@export var walk_state:State
@export var jump_state:State
@export var plancha_state:State
@export var shoot_state:State

func on_enter():
	animation_player.play("Run")

func state_process(_delta: float) -> void:
	if Input.is_action_just_pressed("shootActionP2"):
		next_state = shoot_state
	
	elif Input.is_action_pressed("CorrerP2") and Input.is_action_just_pressed("AbajoP2") and father.velocity.x != 0:
		next_state = plancha_state
	
	elif father.velocity.x != 0 and not Input.is_action_pressed("CorrerP2"):
		next_state = walk_state
		
	elif father.velocity.x == 0:
		next_state = idle_state
		
	elif father.velocity.y != 0:
		next_state = jump_state
	
