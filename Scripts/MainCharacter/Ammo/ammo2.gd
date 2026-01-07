extends Node2D
class_name Ammo

@export var ammo_movement_speed = 900 # Velocidad a la que se desplazará
var direction = Vector2.RIGHT # Por defecto, se sobrescribe al disparar

func _physics_process(delta):
	position += direction * ammo_movement_speed * delta # Mueve la bala dependiendo del movimiento

#(DEBUG)
func _on_ammo_area_2d_body_entered(body):
	if body.is_in_group("Enemigos"):
		print("La bala colisiono con el enemigo")

func _on_ammo_area_2d_body_exited(body):
	if body.is_in_group("Enemigos"):
		print("La bala salio del enemigo")
