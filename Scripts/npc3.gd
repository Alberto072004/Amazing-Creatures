extends Node2D

const NPC3 = preload("res://dialogues/npc3.dialogue")

var interactuar = false

func _ready():
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _process(delta):
	if interactuar and Input.is_action_just_pressed("ui_accept") and not GameManager.activo:
		DialogueManager.show_dialogue_balloon(NPC3, "start")



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
