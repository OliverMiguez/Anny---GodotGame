extends "res://Scripts/GeneralStates/Util/State.gd"

@export var idle_state:State
@export var walk_state:State
@export var run_state:State
@export var crouch_state:State

@onready var roll_timer: Timer = $"../../RollTimer"

func on_enter():
	roll_timer.start()
	animation_player.play("Roll")

func state_process(_delta: float) -> void:

	if father.velocity.x == 0:
		next_state = idle_state

func _on_roll_timer_timeout() -> void:
	if father.velocity.x == 0 and Input.is_action_pressed("ui_down"):
		next_state = crouch_state

	else:
		next_state = idle_state
