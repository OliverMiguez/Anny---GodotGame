extends "res://Scripts/GeneralStates/Util/State.gd"

var can_rol:bool = true

@onready var roll_timer_cooldown: Timer = $"../../RollTimerCooldown"

@export var idle_state:State
@export var walk_state:State
@export var run_state:State
@export var crouch_state:State

func on_enter():
	if can_rol == true:
		father.can_move = false
		
		father.velocity.x = (
		1 if father.main_character_animations.flip_h == false else -1
	) * father.ROLLING_SPEED
	
		animation_player.play("Roll")
	else:
		return
	
func state_process(_delta: float) -> void:
	# No need for logic here as the state changes on animation_finished
	pass

func _on_animation_finished():
	if animation_player.animation == "Roll":
		can_rol = false
		roll_timer_cooldown.start()
		father.can_move = true
		next_state = idle_state

func on_exit():
	father.can_move = true

## Activa un cooldown para volver a ejecutar la funcion
func _on_roll_timer_cooldown_timeout() -> void:
	if can_rol == false:
		can_rol = true
