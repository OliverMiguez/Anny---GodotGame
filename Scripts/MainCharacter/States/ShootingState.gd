extends "res://Scripts/GeneralStates/Util/State.gd"

@export var idle_state:State

var can_change_state = false # Condición que permite cambiar a otro estado

func on_enter():
	# Cuando solo se presiona una vez el botón de disparar
		animation_player.play("Shoot")
		await animation_player.animation_finished # Espera a que la animación finalice
		can_change_state = true # Permite cambiar de estado

func state_process(_delta: float) -> void:
	if can_change_state == true:
		can_change_state = false # Reestablece la condición, para permitir volver cambiar
		next_state = idle_state
