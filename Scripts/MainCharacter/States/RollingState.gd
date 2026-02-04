extends "res://Scripts/GeneralStates/Util/State.gd"


@onready var roll_timer_cooldown: Timer = $"../../RollTimerCooldown"

@export var idle_state:State
@export var walk_state:State
@export var run_state:State
@export var crouch_state:State

func on_enter():
	print("Actualmente en Roll")
	father.can_move = false
	
	father.velocity.x = (
	1 if father.main_character_animations.flip_h == false else -1
) * father.ROLLING_SPEED

	animation_player.play("Roll")

	
func state_process(_delta: float) -> void:
	pass

func _on_animation_finished():
	print("Ejecutando _on_animation_finished")
	father.can_move = true
	next_state = idle_state
	print("[ROLL]: Cambiando a idle")
		

func on_exit():
	father.can_move = true
