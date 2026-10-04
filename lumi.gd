extends CharacterBody2D

@onready var joystick = $"../HUD/Joystick"
var velocidad = 400.0 
var invulnerable = false

func _ready() -> void:
	# PI radianes equivale a 180 grados (apuntando hacia abajo)
	rotation = PI

func _physics_process(_delta):
	var direccion = joystick.vector_direccion
	
	# Inercia para el nado
	velocity = velocity.lerp(direccion * velocidad, 0.1)
	
	if direccion != Vector2.ZERO:
		rotation = direccion.angle() + PI / 2
		
	move_and_slide()
	
	# Límites de la pantalla
	global_position.x = clamp(global_position.x, 30, 690)
	global_position.y = clamp(global_position.y, 30, 1250)

func recibir_dano():
	invulnerable = true
	$Sprite2D.modulate.a = 0.5 

	# Esperamos 1.5 segundos
	await get_tree().create_timer(1.5).timeout

	# Regresamos a la normalidad
	invulnerable = false
	$Sprite2D.modulate.a = 1.0


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_zona_transicion_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
