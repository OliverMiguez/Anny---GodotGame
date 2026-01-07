extends Node2D
class_name Ammo

@export var ammo_movement_speed = 100 # Velocidad a la que se desplazará
var direction = Vector2.RIGHT # Por defecto, se sobrescribe al disparar

func _physics_process(delta):
	position += direction * ammo_movement_speed * delta # Mueve la bala dependiendo del movimiento
