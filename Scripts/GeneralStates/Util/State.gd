extends Node

class_name State

@export var next_state: State = null #en reposo no hay estado siguiente

@export var father:Node #aqui va la clase que tenga el padre
@export var animation_player:AnimatedSprite2D #aqui va la clase que tenga el padre


#Estas funciones las tienen TODOS los estados.
#Esto es lo que hacen por defecto, pero se pueden reescribir en cada estado
#Las que están relacionadas con eventos, son llamadas desde el script de FiniteStateMachine 
#que es quien gestiona las señales y manda a los correspondientes estados realizar la función que toca


#Estas dos se ejecutan al principio y al final de todos los estados. Se pueden reescribir dentro de cada estado
func on_enter():
	print("State Enter: ", self.name)
	
func on_exit():
	print("State Exit: ", self.name)
