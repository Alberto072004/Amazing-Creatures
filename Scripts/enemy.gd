extends Node2D

const ENEMY1 = preload("res://dialogues/enemy1.dialogue")
const ENEMY2 = preload("res://dialogues/enemy2.dialogue")

var interactuar = false

func _ready():
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _process(delta):
	if interactuar and Input.is_action_just_pressed("ui_accept") and not GameManager.activo:
		# 🚨 LÓGICA DE DECISIÓN DE DIÁLOGO:
		if GameManager.repetir:
			# Si fue derrotado, muestra el diálogo de post-combate
			DialogueManager.show_dialogue_balloon(ENEMY2, "start")
		else:
			# Si no ha sido derrotado, muestra el diálogo normal (que lleva al combate)
			DialogueManager.show_dialogue_balloon(ENEMY1, "start")



func _on_area_2d_area_entered(area: Area2D) -> void:
	interactuar = true
	pass # Replace with function body.


func _on_area_2d_area_exited(area: Area2D) -> void:
	interactuar = false
	pass # Replace with function body.

func _on_dialogue_started(dialogue):
	GameManager.activo = true

func _on_dialogue_ended(dialogue):
	await get_tree().create_timer(0.2).timeout
	GameManager.activo = false
	if not GameManager.repetir:
		# Guarda la ruta antes de ir al combate
		GameManager.escena_de_retorno = get_tree().current_scene.scene_file_path
		# Ir a la escena de combate
		get_tree().change_scene_to_file("res://Scenes/control.tscn")
