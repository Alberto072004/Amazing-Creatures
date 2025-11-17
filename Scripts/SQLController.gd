extends Control

var database : SQLite 

var criatures = [
	"Bulbasaur", "Ivysaur", "Venusaur",
	"Charmander", "Charmeleon", "Charizard",
	"Squirtle", "Wartortle", "Blastoise",
	"Caterpie", "Metapod", "Butterfree",
	"Weedle", "Kakuna", "Beedrill",
	"Pidgey", "Pidgeotto", "Pidgeot",
	"Rattata", "Raticate"
]

var hp = [
	20, 10, 20, 25, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
]

var speed = [
	30, 35, 25, 15, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
]

var types = ["Agua", "Fuego", "Planta"]

var criature_types = [
		3, 3, 3,  # Bulbasaur, Ivysaur, Venusaur
		2, 2, 2,  # Charmander, Charmeleon, Charizard
		1, 1, 1,  # Squirtle, Wartortle, Blastoise
		3, 3, 3,  # Caterpie, Metapod, Butterfree
		3, 3, 3,  # Weedle, Kakuna, Beedrill
		3, 3, 3,  # Pidgey, Pidgeotto, Pidgeot
		3, 3      # Rattata, Raticate
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

func createTable() -> void:
	var criaturesTable = {
		"id" = {"data_type":"int", "primary_key":true, "not_null":true, "auto_increment":true},
		"name" = {"data_type":"text"},
		"hp" = {"data_type":"int"},
		"speed" = {"data_type":"int"},
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
	if existentes.size() == criatures.size():
		print("La tabla ya tiene criaturas.")
		return
	for i in range(criatures.size()):
		database.insert_row("criatures", {
			"name": criatures[i],
			"hp": hp[i],
			"speed": speed[i],
			"id_type": criature_types[i]
		})

	print("Criaturas insertadas correctamente.")
	
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
		database.insert_row("movements", {"name": movements[i], "damage": movementDamage[i], "type_id": movementTypes[i]})
	print("Movimientos insertados correctamente.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
