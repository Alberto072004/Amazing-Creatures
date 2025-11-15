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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	database = SQLite.new() #Creamos la Base de datos
	database.path="res://data.db" #Creamos el archivo data
	database.open_db() #Abrimos la base datos
	createTable()
	insertCriatures()

func createTable() -> void:
	var criaturesTable = {
		"id" = {"data_type":"int", "primary_key":true, "not_null":true, "auo_increment":true},
		"name" = {"data_type":"text"}
	}
	database.create_table("Criatures", criaturesTable)
	
func insertCriatures() -> void:
	# Comprueba cuántas criaturas hay ya en la tabla
	var existentes = database.select_rows("Criatures", "id", ["1=1"]) # Si pongo [""] o [] no funcionaba
	print(existentes)
	print(existentes.size())
	if existentes.size() == 20:
		print("La tabla ya tiene criaturas. No se insertan de nuevo.")
		return
	# Si está vacía, insertamos
	for nombre in criatures:
		database.insert_row("Criatures", {"name": nombre})
	
	print("Criaturas insertadas correctamente.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
