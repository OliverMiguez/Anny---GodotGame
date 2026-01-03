extends Control

enum popupIds {
	OPCION_RONDAS,
	PROXIMAMENTE
}
@onready var popup_menu = $PopupMenu # Variable que representa al nodo del popup

## Se ejecuta al inicio de la escena
func _ready():
	popup_menu.add_item("Modo por rondas", popupIds.OPCION_RONDAS)
	popup_menu.add_item("Próximamente", popupIds.PROXIMAMENTE)

## Cuando se presiona el botón de jugar
func _on_jugar_pressed():
	popup_menu.popup() # Cuando se presiona jugar muestra el popup


## Cuando se elige una opcion del popup
func _on_popup_menu_id_pressed(id):
	print(id)
	
	match id: # Según la opción presionada muestra o hace una cosa 
		popupIds.OPCION_RONDAS:
			print("Accediendo al formato de juego por rondas")
			get_tree().change_scene_to_file("res://Scenes/Test/mapa_prueba.tscn") # Cambia a la escena del mapa
		popupIds.PROXIMAMENTE:
			print("Opción no válida por el momento")

func _on_popup_menu_index_pressed(index):
	print(index)
