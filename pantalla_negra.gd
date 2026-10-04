extends ColorRect

@onready var texto = $RichTextLabel

func _ready():
	# 1. Congelamos a Lumi al inicio
	var lumi = get_tree().current_scene.get_node_or_null("Lumi")
	if lumi:
		lumi.set_physics_process(false)
	
	# 2. Mostramos el texto "¿Dónde estoy?"
	texto.visible_ratio = 0.0
	var tween_texto = get_tree().create_tween()
	tween_texto.tween_property(texto, "visible_ratio", 1.0, 1.0)
	
	# 3. Esperamos los 3 segundos de intro
	await get_tree().create_timer(3.0).timeout
	
	# 4. Desvanecemos la pantalla negra (2 segundos)
	var tween_fade = get_tree().create_tween()
	tween_fade.tween_property(self, "modulate:a", 0.0, 2.0)
	await tween_fade.finished
	
	# 5. Reactivamos a Lumi
	if lumi:
		lumi.set_physics_process(true)
		
	# 6. Hacemos aparecer suavemente el texto del tutorial (fade in de 1 segundo)
	# Buscamos TextoTutorial en la escena actual
	var texto_tutorial = get_tree().current_scene.find_child("TextoTutorial", true, false)
	if texto_tutorial:
		var tween_tut = get_tree().create_tween()
		tween_tut.tween_property(texto_tutorial, "modulate:a", 1.0, 1.0)
	
	# 7. Eliminamos la pantalla negra
	queue_free()
