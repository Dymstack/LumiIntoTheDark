extends CanvasLayer # (O Control, dependiendo de tu nodo raíz)

# Cargamos las imágenes (cambia los nombres si tus archivos se llaman distinto)
var corazon_rojo = preload("res://Elementos Visuales/Icons/RedHeart.png")
var corazon_negro = preload("res://Elementos Visuales/Icons/BlackHeart.png")

func _process(_delta):
	# Evaluar el Corazón 3
	if Global.vidas >= 3:
		$HBoxContainer/Corazon3.texture = corazon_rojo
	else:
		$HBoxContainer/Corazon3.texture = corazon_negro
		
	# Evaluar el Corazón 2
	if Global.vidas >= 2:
		$HBoxContainer/Corazon2.texture = corazon_rojo
	else:
		$HBoxContainer/Corazon2.texture = corazon_negro
		
	# Evaluar el Corazón 1
	if Global.vidas >= 1:
		$HBoxContainer/Corazon1.texture = corazon_rojo
	else:
		$HBoxContainer/Corazon1.texture = corazon_negro

# Muestra u oculta el botón según el nivel
func mostrar_boton_linterna(activar: bool) -> void:
	if has_node("BotonLinterna"):
		$BotonLinterna.visible = activar

# Conecta la señal pressed() de tu BotonLinterna a esta función
func _on_boton_linterna_pressed() -> void:
	var lumi = get_tree().get_first_node_in_group("Lumi")
	if lumi and lumi.has_method("activar_destello"):
		lumi.activar_destello()
