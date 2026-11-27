extends Node2D
 
enum Tamano { PEQUENA, MEDIANA, GRANDE }
 
@export var tamano: Tamano = Tamano.PEQUENA
@export var decorativa := false     # sin daño ni atracción
@export var mostrar_zona := false   # dibuja el radio de atracción (para ajustar)
@export var luz_color := Color(0.4, 0.85, 1.0)
@export var luz_intensidad := 0.6
 
# escala visual, radio de atracción (px), fuerza máxima (px/s), radio de la luz (px)
const PRESETS := {
	Tamano.PEQUENA: {"escala": 0.25, "radio": 220.0, "fuerza": 40.0, "luz": 110.0},
	Tamano.MEDIANA: {"escala": 0.40, "radio": 300.0, "fuerza": 85.0, "luz": 150.0},
	Tamano.GRANDE:  {"escala": 0.65, "radio": 380.0, "fuerza": 130.0, "luz": 210.0},
}
 
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_dano: Area2D = $AreaDano
 
var radio := 0.0
var fuerza := 0.0
var luz: PointLight2D
var fase := 0.0
 
func _ready():
	var p = PRESETS[tamano]
	radio = p["radio"]
	fuerza = p["fuerza"]
	sprite.scale = Vector2.ONE * p["escala"]
	area_dano.scale = Vector2.ONE * p["escala"]
	area_dano.monitoring = not decorativa
	fase = randf() * TAU
	crear_luz(p["luz"])
	sprite.play("default")
	queue_redraw()
 
func crear_luz(radio_luz: float):
	var grad = Gradient.new()
	grad.set_color(0, Color.WHITE)
	grad.set_color(1, Color(1, 1, 1, 0))
	var tex = GradientTexture2D.new()
	tex.gradient = grad
	tex.fill = GradientTexture2D.FILL_RADIAL
	tex.fill_from = Vector2(0.5, 0.5)
	tex.fill_to = Vector2(1.0, 0.5)
	tex.width = 256
	tex.height = 256
	luz = PointLight2D.new()
	luz.texture = tex
	luz.color = luz_color
	luz.energy = luz_intensidad
	luz.texture_scale = radio_luz / 128.0
	add_child(luz)
 
func _draw():
	if mostrar_zona and not decorativa:
		draw_circle(Vector2.ZERO, radio, Color(0.3, 0.8, 1.0, 0.12))
 
func _process(delta):
	# La luz "respira" suavemente
	fase += delta * 2.0
	luz.energy = luz_intensidad * (0.85 + 0.15 * sin(fase))
 
func _physics_process(_delta):
	if decorativa:
		return
	var lumi = get_tree().get_first_node_in_group("Lumi")
	if lumi == null:
		return
 
	# Atracción: más fuerte cuanto más cerca del centro
	var hacia = global_position - lumi.global_position
	var dist = hacia.length()
	if dist < radio and dist > 1.0:
		var t = 1.0 - dist / radio   # 0 en el borde, 1 en el centro
		var empuje = fuerza * lerpf(0.3, 1.0, t)
		lumi.agregar_atraccion(hacia / dist * empuje)
 
	# Daño al tocar la campana
	for body in area_dano.get_overlapping_bodies():
		if body.name == "Lumi":
			body.recibir_dano("medusa_dano")
