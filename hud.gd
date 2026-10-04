extends CanvasLayer # (O Control, dependiendo de tu nodo raíz)

# Cargamos las imágenes (cambia los nombres si tus archivos se llaman distinto)
var corazon_rojo = preload("res://RedHeart.png")
var corazon_negro = preload("res://BlackHeart.png")

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
