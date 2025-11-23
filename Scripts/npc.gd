extends Node2D

var interactuar = false

func _process(delta):
	if interactuar and Input.is_action_just_pressed("ui_accept"):
		print("Iniciar dialogo")



func _on_area_2d_area_entered(area: Area2D) -> void:
	interactuar = true
	pass # Replace with function body.


func _on_area_2d_area_exited(area: Area2D) -> void:
	interactuar = false
	pass # Replace with function body.
