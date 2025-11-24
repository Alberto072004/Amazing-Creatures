extends Control

var database : SQLite 

@onready var label: Label = $Label
@onready var texture_rect: TextureRect = $TextureRect

var criatures = [
	"Floracorn", "Flamepico", "Aguazurro",
	"Vinegato", "Hojaferno", "Raízvivo", "Hierbamala",
	"Cenizorro", "Luzfuego", "Ascuarón", "Escarallama",
	"Burbujeo", "Nautigato", "Hidromar", "Ardigua"
]

var imagenes = ["res://Assets/Criaturas/Floracorn.png", "res://Assets/Criaturas/Flamepico.png", "res://Assets/Criaturas/Aguazurro.png",
	"res://Assets/Criaturas/Vinegato.png", "res://Assets/Criaturas/Hojaferno.png", "res://Assets/Criaturas/Raízvivo.png",
	"res://Assets/Criaturas/Hierbamala.png", "res://Assets/Criaturas/Cenizorro.png", "res://Assets/Criaturas/Luzfuego.png",
	"res://Assets/Criaturas/Ascuarón.png", "res://Assets/Criaturas/Escarallama.png", "res://Assets/Criaturas/Burbujeo.png",
	"res://Assets/Criaturas/Nautigato.png", "res://Assets/Criaturas/Hidromar.png", "res://Assets/Criaturas/Ardigua.png"
]

var hp = [
	20, 10, 20, 25, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
]

var speed = [
	30, 35, 25, 15, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
]

var types = ["Agua", "Fuego", "Planta"]

var criature_types = [
		3, 2, 1,  
		3, 3, 3, 3,
		2, 2, 2, 2,
		1, 1, 1, 1,    
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
	var index = 0
	label.text = criatures[index]
	var textura = load(imagenes[index])
	texture_rect.texture = textura

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
		database.insert_row("movements", {
			"name": movements[i], 
			"damage": movementDamage[i], 
			"type_id": movementTypes[i]})
	print("Movimientos insertados correctamente.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
