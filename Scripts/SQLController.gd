extends Control

var database : SQLite 

signal textboxClosed

@onready var Vinegato: TextureRect = $EnemyContainer1/Enemy
@onready var progress_barVinegato: ProgressBar = $EnemyContainer1/ProgressBar


@onready var Floracorn: TextureRect = $AllyContainer1/Ally
@onready var progress_barFloracorn: ProgressBar = $AllyContainer1/ProgressBar


var criatures = [
	"Floracorn", "Flamepico", "Aguazurro",
	"Vinegato","Escarallama", "Nautipardo"
]


var hp = [
	100, 100, 100, 100, 100, 100
]

var types = ["Agua", "Fuego", "Planta"]

var criature_types = [
		3, 2, 1,  
		3, 2, 1  
	]

var movements = ["Pistola agua", "Hidrobomba", "Ascuas", "Lanzallamas", "Latigo cepa", "Tormenta floral"]

var movementTypes = [1, 1, 2, 2, 3, 3]

var movementDamage = [20, 40, 15, 35, 18, 45]

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
	var enemy1 = preload("res://Assets/Criaturas/Vinegato.png")
	Vinegato.texture = enemy1
	var max_hp = getEnemy(1)
	progress_barVinegato.get_node("hp").text = "HP: %d/%d" % [25, max_hp]
	
	var ally1 = preload("res://Assets/Criaturas/Floracorn.png")
	Floracorn.texture = ally1
	max_hp = getAlly(1)
	progress_barFloracorn.get_node("hp").text = "HP: %d/%d" % [25, max_hp]
	
	
	
	texto("Jefe te desafia")
	await get_tree().create_timer(.25).timeout
	$PanelAttacks.show()

func _input(event: InputEvent) -> void:
	if(Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $TextBox.visible:
		$TextBox.hide()
		emit_signal("textboxClosed")

func texto(text):
	$TextBox.show()
	$TextBox/Label.text = text
	
#func updateLifeLabel(index: int) -> void:
	#if index >= 0 and index < criatures.size():
		#vida.text = str("Vida: ") + str(hp[index])
	#else:
		#vida.text = "Vida: 0"

#func setHealth(progress_bar, health, max_health):
#	progress_bar.value = health
#	progress_bar.max_health = max_health
#	progress_bar.get_node("Label").text = "HP:%d/%d" % [health, max_health]

func createTable() -> void:
	var criaturesTable = {
		"id" = {"data_type":"int", "primary_key":true, "not_null":true, "auto_increment":true},
		"name" = {"data_type":"text"},
		"hp" = {"data_type":"int"},
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
			"id_type": criature_types[i]
		})
	print("Criaturas insertadas correctamente.")

func getEnemy(numId: int) -> int:
	# numId es el enemigo que quiero, que van numerados del 4 al 6 en la tabla de 
	# criaturas. Por lo que si envian el enemigo 1, tenemos que buscar la posición 4 (numId+3) de la tabla
	var id_a_buscar = numId + 3
	var query = "SELECT hp FROM criatures WHERE id = " + str(id_a_buscar)

	var query_success = database.query(query)
	if query_success == true:
		var result_data = database.query_result
		
		#print("✅ Consulta exitosa para ID:", id_a_buscar)
		#print("Tipo de datos (result_data):", typeof(result_data))
		#print("Número de filas:", result_data.size())
		
		if result_data.size() > 0:
			var hp_value = result_data[0]["hp"]
			#print("Se encontró la criatura con hp:", hp_value)
			return hp_value
		else:
			print("No se encontró la criatura con ID:", id_a_buscar)
			return 0
	else:
		# La ejecución de la consulta falló (error de conexión o SQL)
		print("❌ ERROR en la consulta de base de datos. Query:", query)
		return 0

func getAlly(numId: int) -> int:
	# numId es el aliado que quiero, que van numerados del 1 al 3 en la tabla de 
	# criaturas. Por lo que si envian el enemigo 1, tenemos que buscar la posición 1 de la tabla
	var id_a_buscar = numId
	var query = "SELECT hp FROM criatures WHERE id = " + str(id_a_buscar)

	var query_success = database.query(query)
	if query_success == true:
		var result_data = database.query_result
		
		#print("✅ Consulta exitosa para ID:", id_a_buscar)
		#print("Tipo de datos (result_data):", typeof(result_data))
		#print("Número de filas:", result_data.size())
		
		if result_data.size() > 0:
			var hp_value = result_data[0]["hp"]
			#print("Se encontró la criatura con hp:", hp_value)
			return hp_value
		else:
			print("No se encontró la criatura con ID:", id_a_buscar)
			return 0
	else:
		# La ejecución de la consulta falló (error de conexión o SQL)
		print("❌ ERROR en la consulta de base de datos. Query:", query)
		return 0


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
