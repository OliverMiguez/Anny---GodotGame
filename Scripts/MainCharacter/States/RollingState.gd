extends "res://Scripts/GeneralStates/Util/State.gd"

var can_rol:bool = true

@onready var roll_timer_cooldown: Timer = $"../../RollTimerCooldown"

@export var idle_state:State
@export var walk_state:State
@export var run_state:State
@export var crouch_state:State

func on_enter():
	if can_rol == true:
		animation_player.play("Roll")
	else:
		return
	

func state_process(_delta: float) -> void:
	if animation_player.is_playing() and animation_player.animation == "Roll":
		can_rol = false
		roll_timer_cooldown.start()
		return 

	var direction = Input.get_axis("IzquierdaP1", "DerechaP1")
	
	if direction != 0:
		if Input.is_action_pressed("CorrerP1"):
			next_state = run_state
		else:
			next_state = walk_state
	else:
		next_state = idle_state
	
	return

## Activa un cooldown para volver a ejecutar la funcion
func _on_roll_timer_cooldown_timeout() -> void:
	if can_rol == false:
		can_rol = true
