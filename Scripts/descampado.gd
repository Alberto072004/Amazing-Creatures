extends Node2D


# Ruta al archivo de diálogo que quieres mostrar (el de npc3 en tu caso)
const DESCAMPADO = preload("res://dialogues/descampado.dialogue")

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	GameManager.activo = true 
	DialogueManager.show_dialogue_balloon(DESCAMPADO, "start")

# 🚨 Esta función se llama cuando el usuario termina el diálogo (llega a => END)
func _on_dialogue_ended(dialogue):
	# Asegura que el motor termine de limpiar
	await get_tree().create_timer(0.2).timeout
	GameManager.activo = false
	get_tree().change_scene_to_file("res://Scenes/juego.tscn")
	
	
