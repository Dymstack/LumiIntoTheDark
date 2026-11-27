extends CharacterBody2D
 
@onready var joystick = $"../HUD/Joystick"
var velocidad = 200.0 
var invulnerable = false
var destello_en_curso = false
var automatico = false
 
# Nado (inercia propia) y atracción de las medusas, por separado
var nado := Vector2.ZERO
var atraccion := Vector2.ZERO
var atraccion_maxima := 150.0   # menor que velocidad: siempre se puede escapar
 
func _ready() -> void:
	add_to_group("Lumi")
	# PI radianes equivale a 180 grados (apuntando hacia abajo)
	rotation = PI
 
func _physics_process(_delta):
	if automatico:
		return
	var direccion = joystick.vector_direccion
	
	# Inercia para el nado (separada de la atracción)
	nado = nado.lerp(direccion * velocidad, 0.1)
	
	if direccion != Vector2.ZERO:
		rotation = direccion.angle() + PI / 2
		
	# El nado y la atracción se suman solo para mover; la atracción se reinicia cada frame
	velocity = nado + atraccion.limit_length(atraccion_maxima)
	atraccion = Vector2.ZERO
	move_and_slide()
	
	# Límites de la pantalla
	global_position.x = clamp(global_position.x, 30, 690)
	global_position.y = clamp(global_position.y, 30, 1250)
 
func agregar_atraccion(fuerza: Vector2) -> void:
	atraccion += fuerza
 
func recibir_dano(sonido_extra := "") -> void:
	# Un único punto donde se descuentan vidas
	if invulnerable:
		return
	invulnerable = true
	print("GOLPE | vidas antes del golpe: ", Global.vidas)
	print_stack()
	Global.vidas -= 1
	if Global.vidas <= 0:
		Global.derrota()
		return
 
	Audio.sfx("dano_lumi")
	if sonido_extra != "":
		Audio.sfx(sonido_extra)
 
	modulate.a = 0.5
	await get_tree().create_timer(1.5).timeout
	if not is_inside_tree():
		return
	invulnerable = false
	modulate.a = 1.0
 
func activar_destello() -> void:
	if destello_en_curso:
		return
	
	destello_en_curso = true
	Audio.sfx("linterna")
	var luz = $LuzLinterna
	var tween = create_tween()
	
	# 1. Sube brillo y alcance rápido (0.25 s)
	tween.tween_property(luz, "energy", 1.8, 0.25).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(luz, "texture_scale", 2.2, 0.25)
	
	# 2. Se sostiene iluminando el laberinto (0.5 s)
	tween.tween_interval(0.5)
	
	# 3. Se desvanece de vuelta a su estado normal suavemente (1.2 s)
	tween.tween_property(luz, "energy", 0.2, 1.2).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(luz, "texture_scale", 1.0, 1.2)
	
	# Permite volver a usar la linterna cuando termina
	tween.finished.connect(func(): destello_en_curso = false)
 
func encender_luz_laberinto() -> void:
	if has_node("LuzLinterna"):
		$LuzLinterna.visible = true
		$LuzLinterna.energy = 0.2  # Su luz tenue ambiental inicial
