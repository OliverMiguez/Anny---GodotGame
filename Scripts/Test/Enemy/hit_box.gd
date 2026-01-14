extends Area2D


func _on_area_entered(area):
	if area.is_in_group("Balas"):
		print("Bala recibida correctamente por el enemigo !!!")
