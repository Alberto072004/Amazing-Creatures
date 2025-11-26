extends Control

var database : SQLite 

signal textboxClosed

@onready var Enemy: TextureRect = $EnemyContainer1/Enemy
@onready var progress_bar_enemy: ProgressBar = $EnemyContainer1/ProgressBar

@onready var Ally: TextureRect = $AllyContainer1/Ally
@onready var progress_bar_ally: ProgressBar = $AllyContainer1/ProgressBar
@onready var button: Button = $PanelAttacks/Attacks/Button

var dict_enemy: Dictionary 
var dict_ally : Dictionary

var criatures = [
	"Floracorn", "Flamepico", "Aguazurro",
	"Vinegato","Escarallama", "Nautipardo"
]

var imagenes = [
	"Floracorn.png", "Flamepico.png", "Aguazurro.png",
	"Vinegato.png","Escarallama.png", "Nautipardo.png"
]


var hp = [
	100, 100, 100, 100, 100, 100
]

var types = ["Agua", "Fuego", "Planta"]

var criature_types = [
		3, 2, 1,  
		3, 2, 1  
	]

var movements = ["Hidrobomba", "Lanzallamas", "Tormenta floral"]

var movementTypes = [1, 2, 3]

var movementDamage = [40, 35, 45]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	database = SQLite.new() #Creamos la Base de datos
	database.path="res://data.db" #Creamos el archivo data
	database.foreign_keys = true
	database.open_db() #Abrimos la base datos
	createTable()
	insertTypes()
	insertMovements()
	insertCriatures()
	#updateLifeLabel(0)
	#setHealth($EnemyContainer1/ProgressBar, State.current_health, State.max_health)
	$TextBox.hide()
	$PanelAttacks.hide()
	#var index = 0
	#label.text = criatures[index]
	
	load_next_enemy()
	load_next_ally()
	
	texto("Jefe te desafia")
	await get_tree().create_timer(.25).timeout

	button.text = dict_ally["dict_movement"]["name"]
	$PanelAttacks.show()




func _input(event: InputEvent) -> void:
	if(Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $TextBox.visible:
		$TextBox.hide()
		emit_signal("textboxClosed")

func texto(text):
	$TextBox.show()
	$TextBox/Label.text = text
	

func createTable() -> void:
	var criaturesTable = {
		"id" = {"data_type":"int", "primary_key":true, "not_null":true, "auto_increment":true},
		"name" = {"data_type":"text"},
		"hp" = {"data_type":"int"},
		"image" = {"data_type":"text"},
		"id_type" = {"data_type":"int", "foreign_key":"type.id", "not_null":true}
	}
	database.create_table("criatures", criaturesTable)
	
	var typeTable = {
		"id" = {"data_type":"int", "primary_key":true, "not_null":true, "auto_increment":true},
		"name" = {"data_type":"text"}
	}
	database.create_table("type", typeTable)
	
	var movementsTable = {
		"id" = {"data_type":"int", "primary_key":true, "not_null":true, "auto_increment":true},
		"name" = {"data_type":"text"},
		"damage" = {"data_type":"int"},
		"type_id" = {"data_type":"int", "foreign_key":"type.id", "not_null":true}
	}
	database.create_table("movements", movementsTable)
	
func insertCriatures() -> void:
	var existentes = database.select_rows("criatures", "id", ["1=1"])
	if existentes.size() > 0:  #== criatures.size():
		print("La tabla ya tiene criaturas.")
		return
	for i in range(criatures.size()):
		database.insert_row("criatures", {
			"name": criatures[i],
			"hp": hp[i],
			"image": imagenes[i],
			"id_type": criature_types[i]
		})
	print("Criaturas insertadas correctamente.")

func getEnemy(numId: int) -> Dictionary:
	return getCriature(numId)

func getAlly(numId: int) -> Dictionary:
	return getCriature(numId)

func getCriature(id_a_buscar: int) -> Dictionary:
	var query = "SELECT hp, image FROM criatures WHERE id = " + str(id_a_buscar)

	var query_success = database.query(query)
	if query_success == true:
		var result_data = database.query_result
		
		#print("✅ Consulta exitosa para ID:", id_a_buscar)
		#print("Tipo de datos (result_data):", typeof(result_data))
		#print("Número de filas:", result_data.size())
		
		if result_data.size() > 0:
			#var hp_value = result_data[0]["hp"]
			##print("Se encontró la criatura con hp:", hp_value)
			#return hp_value
			
			# 1. Obtenemos la única fila de resultados (que es un Dictionary)
			var row: Dictionary = result_data[0]
			
			# 2. Extraemos los valores
			var criature_hp: int = row["hp"]
			var criature_image: String = row["image"]
			
			# 3. Creamos el Dictionary de retorno con las claves que desees
			var criature_details: Dictionary = {
				"hp": criature_hp,
				"image": criature_image,
				"num": id_a_buscar
			}
			
			print("✅ Movimiento único encontrado para ID", id_a_buscar, ":", criature_details)
			return criature_details
		else:
			print("No se encontró la criatura con ID:", id_a_buscar)
			return {}
	else:
		# La ejecución de la consulta falló (error de conexión o SQL)
		print("❌ ERROR en la consulta de base de datos. Query:", query)
		return {}

func getMovementEnemy(numId: int) -> Dictionary:
	return getMovement(numId)
	
func getMovementAlly(numId) -> Dictionary:
	return getMovement(numId)

func getMovement(id_a_buscar: int) -> Dictionary:
	var query =  "select m.name, m.damage
					from criatures c
					inner join type t on t.id = c.id_type
					inner join movements m on m.type_id = c.id_type
					where c.id = " + str(id_a_buscar)
	
	var query_success = database.query(query)
	if query_success == true:
		var result_data = database.query_result
		
		if result_data.size() > 0:
			# 1. Obtenemos la única fila de resultados (que es un Dictionary)
			var row: Dictionary = result_data[0]
			
			# 2. Extraemos los valores
			var move_name: String = row["name"]
			var move_damage: int = row["damage"]
			
			# 3. Creamos el Dictionary de retorno con las claves que desees
			var movement_details: Dictionary = {
				"name": move_name,
				"damage": move_damage
			}
			
			print("✅ Movimiento único encontrado para ID", id_a_buscar, ":", movement_details)
			return movement_details
		else:
			print("No se encontró la criatura con ID:", id_a_buscar)
			return {}
	else:
		print("❌ ERROR en la consulta de base de datos. Query:", query)
		return {}

func insertTypes() -> void:
	var existentes = database.select_rows("type", "id", ["1=1"])
	if existentes.size() == types.size():
		print("La tabla ya tiene tipos.")
		return
	for nombre in types:
		database.insert_row("type", {"name": nombre})
	print("Tipos insertados correctamente.")

func insertMovements() -> void:
	var existentes = database.select_rows("movements", "id", ["1=1"])
	if existentes.size() == movements.size():
		print("La tabla ya tiene movimientos.")
		return
	for i in range(movements.size()):
		database.insert_row("movements", {
			"name": movements[i], 
			"damage": movementDamage[i], 
			"type_id": movementTypes[i]})
	print("Movimientos insertados correctamente.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_next_enemy() -> void:
	var numEnemy : int
	if dict_enemy == null or dict_enemy.is_empty():
		# numEnemy es el enemigo que quiero, que van numerados del 4 al 6 en la tabla de 
		# criaturas. Por lo que si envian el enemigo 1, tenemos que buscar la posición 4 (numId+3) de la tabla
		numEnemy = 4
	else:
		numEnemy = dict_enemy["num"] + 1
	
	dict_enemy = getEnemy(numEnemy)
	Enemy.texture = load("res://Assets/Criaturas/" + dict_enemy["image"])
	dict_enemy["current_hp"] = dict_enemy["hp"]
	progress_bar_enemy.get_node("hp").text = "HP: %d/%d" % [dict_enemy["current_hp"], dict_enemy["hp"]]
	progress_bar_enemy.value = dict_enemy["current_hp"]
	print("Movimiento enemigo ",dict_enemy["num"], " - ",getMovementEnemy(dict_enemy["num"]))
	dict_enemy["dict_movement"] =  getMovementEnemy(dict_enemy["num"])


func load_next_ally() -> void:
	var numAlly : int
	if dict_ally == null or dict_ally.is_empty():
		# numAlly es el aliado que quiero, que van numerados del 1 al 3 en la tabla de 
		# criaturas. Por lo que si envian el aliado 1, tenemos que buscar la posición 1 de la tabla
		numAlly = 1
	else:
		numAlly = dict_ally["num"] + 1
	
	dict_ally = getAlly(numAlly)
	Ally.texture = load("res://Assets/Criaturas/" + dict_ally["image"])
	dict_ally["current_hp"] = dict_ally["hp"]
	progress_bar_ally.get_node("hp").text = "HP: %d/%d" % [dict_ally["current_hp"], dict_ally["hp"]]
	progress_bar_ally.value = dict_ally["current_hp"]
	print("Movimiento aliado ",dict_ally["num"], " - ",getMovementAlly(dict_ally["num"]))
	dict_ally["dict_movement"] =  getMovementAlly(dict_ally["num"])

func _on_button_pressed() -> void:
	print("Has pulsado el botón que te he visto!!!", dict_ally, dict_enemy)
	
	# sacar una imagen de trueno desde el aliado al enemigo
	
	dict_enemy["current_hp"] = max(0, dict_enemy["current_hp"] - dict_ally["dict_movement"]["damage"])
	progress_bar_enemy.get_node("hp").text = "HP: %d/%d" % [dict_enemy["current_hp"], dict_enemy["hp"]]
	progress_bar_enemy.value = dict_enemy["current_hp"]
	
	# Si dict_enemy["current_hp"] = 0 entonces crear en dict_enemy los datos de un siguiente enemigo
	# y si no quedan mas, salir de la escena: load_next_enemy()

	# sacar una imagen de trueno desde el enemigo al aliado 
	
	dict_ally["current_hp"] = max(0, dict_ally["current_hp"] - dict_enemy["dict_movement"]["damage"])
	progress_bar_ally.get_node("hp").text = "HP: %d/%d" % [dict_ally["current_hp"], dict_ally["hp"]]
	progress_bar_ally.value = dict_ally["current_hp"]
	
	# Si dict_ally["current_hp"] = 0 entonces crear en dict_ally los datos de un siguiente aliado
	# y si no quedan mas, salir de la escena: load_next_ally()
	
