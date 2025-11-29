extends Control


func _ready() -> void:
	# 1. Conectar la señal `dialogue_ended` a una función que tú definirás.
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	
	# 2. Iniciar el diálogo (como ya lo tienes)
	DialogueManager.show_example_dialogue_balloon(preload("res://dialogues/historia.dialogue"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# 🚨 Esta función se llamará automáticamente cuando el diálogo termine
func _on_dialogue_ended(dialogue):
	# Es buena práctica esperar un momento para asegurar que el DialogueManager termine la limpieza
	await get_tree().create_timer(0.2).timeout
	
	# Opcional: Si estabas usando el GameManager, desactívalo aquí
	# GameManager.activo = false 
	
	# 3. Cambiar a la escena final
	get_tree().change_scene_to_file("res://Scenes/principio.tscn")
