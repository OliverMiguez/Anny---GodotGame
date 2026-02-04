extends "res://Scripts/GeneralStates/Util/State.gd"

@onready var jump_sound: AudioStreamPlayer2D = $"../../JumpSound"

@export var idle_state:State
@export var walk_state:State
@export var run_state:State
@export var crouch_state:State

func on_enter():
	print("Actualmente en Jump")
	animation_player.play("Jump")
	jump_sound.play()


func state_process(_delta: float) -> void:
	var is_running = Input.is_action_pressed("CorrerP1")
	var is_crouching = Input.is_action_pressed("AbajoP1")
	
	if father.velocity.y >= 0:
		if father.is_on_floor():
			if is_zero_approx(father.velocity.x):
				if is_crouching:
					next_state = crouch_state
				else:
					next_state = idle_state
			else:
				if is_running:
					next_state = run_state
				else:
					next_state = walk_state
			return
