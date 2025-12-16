extends "res://Scripts/GeneralStates/Util/State.gd"
@export var idle_state:State
@export var walk_state:State
@export var run_state:State
@export var crouch_state:State
@export var jump_state:State

# Timers
@onready var plancha_timer: Timer = $"../../PlanchaTimer"

func on_enter():
	plancha_timer.start()
	animation_player.play("Plancha")

func state_process(_delta: float) -> void:
	if father.velocity.x == 0:
		next_state = idle_state

## Para arreglar bugs con las animaciones
func _on_plancha_timer_timeout() -> void:
	if father.velocity.x != 0 and Input.is_action_pressed("Shift") and not Input.is_action_just_pressed("ui_down"):
		next_state = run_state
	elif father.velocity.x != 0:
		next_state = walk_state
	elif father.velocity.x == 0:
		next_state = idle_state

	
