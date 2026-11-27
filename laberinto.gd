extends Node2D

func _ready() -> void:
	# 1. Hacemos visible el botón en el HUD
	if has_node("HUD"):
		$HUD.mostrar_boton_linterna(true)
	
	# 2. Encendemos la linterna de Lumi para este nivel
	var lumi = get_tree().get_first_node_in_group("Lumi")
	if lumi and lumi.has_method("encender_luz_laberinto"):
		lumi.encender_luz_laberinto()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
