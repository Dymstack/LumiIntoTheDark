extends ColorRect

@onready var texto = $RichTextLabel

func _ready():
	# 1. Escondemos el texto al arrancar
	texto.visible_ratio = 0.0
	
	# 2. Hacemos que el texto aparezca como si se estuviera escribiendo (1 segundo)
	var tween_texto = get_tree().create_tween()
	tween_texto.tween_property(texto, "visible_ratio", 1.0, 1.0)
	
	# 3. Esperamos los 3 segundos que dice tu documento
	await get_tree().create_timer(3.0).timeout
	
	# 4. Hacemos el fade out (desvanecer la pantalla negra) durante 2 segundos
	var tween_fade = get_tree().create_tween()
	tween_fade.tween_property(self, "modulate:a", 0.0, 2.0)
	
	# 5. Cuando termine de desvanecerse, borramos esta pantalla negra para que Lumi pueda moverse
	await tween_fade.finished
	queue_free()
