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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	database = SQLite.new() #Creamos la Base de datos
	database.path="res://data.db" #Creamos el archivo data
	database.open_db() #Abrimos la base datos
	createTable()
	insertCriatures()

func createTable() -> void:
	var criaturesTable = {
		"id" = {"data_type":"int", "primary_key":true, "not_null":true, "auto_increment":true},
		"name" = {"data_type":"text"},
		"hp" = {"data_type":"int"},
		"speed" = {"data_type":"int"}
	}
	database.create_table("Criatures", criaturesTable)
	
	var typeTable = {
		"id" = {"data_type":"int", "primary_key":true, "not_null":true, "auto_increment":true},
		"name" = {"data_type":"text"}
	}
	database.create_table("Type", typeTable)
	
	var movementsTable = {
		"id" = {"data_type":"int", "primary_key":true, "not_null":true, "auto_increment":true},
		"name" = {"data_type":"text"},
		"damage" = {"data_type":"int"}
	}
	database.create_table("Movements", movementsTable)
	
func insertCriatures() -> void:
	# Comprueba cuántas criaturas hay ya en la tabla
	var existentes = database.select_rows("Criatures", "id", ["1=1"]) # Si pongo [""] o [] no funcionaba. Funciona porque 1=1 es true
	if existentes.size() == 20:
		print("La tabla ya tiene criaturas. No se insertan de nuevo.")
		return
	# Si está vacía, insertamos
	# for nombre in criatures:
	#	database.insert_row("Criatures", {"name": nombre)
	for i in range(criatures.size()):
		var nombre = criatures[i]
		var puntos_vida = hp[i]
		var velocidad = speed[i]
		database.insert_row("Criatures", {"name": nombre, "hp": puntos_vida, "speed": velocidad})
	print("Criaturas insertadas correctamente.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
