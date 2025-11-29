extends Control

var dialogo = [
	'Hola como estamos',
	'Hola muy buenas',
	'Hola amigo'
]

var dialogo_index: int = 0
var escribiendo: bool = false # Nuevo: bandera para saber si el texto se está mostrando

# Velocidad de escritura (caracteres por segundo)
const VELOCIDAD_ESCRITURA: float = 20.0 

# El RichTextLabel (Asegúrate de que la ruta sea correcta)
@onready var rich_text_label: RichTextLabel = $RichTextLabel 

func _ready() -> void:
	# Inicializa mostrando el primer diálogo
	mostrar_siguiente_linea()

func _input(event: InputEvent) -> void:
	# Usa _input para detectar clics o pulsaciones de forma más limpia
	if event.is_action_pressed("click_izquierdo"): # Reemplaza "click_izquierdo" si usas otra acción
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			# Si el texto se está escribiendo, lo terminamos al instante
			if escribiendo:
				rich_text_label.percent_visible = 1.0
				escribiendo = false
			# Si el texto ya terminó de escribirse, avanzamos a la siguiente línea
			elif dialogo_index < dialogo.size():
				mostrar_siguiente_linea()
			# Si llegamos al final, podemos salir de la escena o hacer algo más
			elif dialogo_index == dialogo.size():
				print("Fin del diálogo. Cerrando escena...")
				# Por ejemplo: get_tree().change_scene_to_file("res://Scenes/overworld.tscn")
				# o get_parent().queue_free() si es un pop-up.

func mostrar_siguiente_linea() -> void:
	if dialogo_index < dialogo.size():
		# 1. Prepara el texto completo
		rich_text_label.bbcode_text = dialogo[dialogo_index]
		
		# 2. Inicializa el efecto de escritura (porcentaje visible a 0)
		rich_text_label.percent_visible = 0.0
		escribiendo = true
		
		# 3. Crea un Tween para animar la propiedad "percent_visible"
		var tween = create_tween()
		
		# Calcula la duración: (Número de caracteres / Velocidad)
		var duracion = float(dialogo[dialogo_index].length()) / VELOCIDAD_ESCRITURA
		
		# Anima la propiedad de 0.0 (oculto) a 1.0 (visible) en 'duracion' segundos
		tween.tween_property(rich_text_label, "percent_visible", 1.0, duracion)
		
		# Conecta una función que se llama cuando el tween termina
		tween.finished.connect(_on_tween_finished)
		
		# Incrementa el índice para la próxima línea
		dialogo_index += 1
		
func _on_tween_finished():
	# Esta función se llama cuando el efecto de escritura termina
	escribiendo = false
