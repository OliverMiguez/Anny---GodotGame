extends Area2D


@export var ammo_movement_speed = 100 # Velocidad a la que se desplazará

func _physics_process(delta):
	var ammo_direction = 1 # 1 derecha -1 izq
	position.x = ammo_direction * ammo_movement_speed * delta # Mueve la bala dependiendo del movimiento
