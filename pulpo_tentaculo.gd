extends Node2D
 
@export var onda_golpe := 0.4
@export var largo_aviso := 140.0
@export var radio_deteccion := 550.0
@export var alcance := 650.0
@export var grosor := 26.0
@export var tiempo_aviso := 0.7
@export var tiempo_fijo := 0.1
@export var descanso := 1.5
@export var giro_golpe := 1.8
 
@onready var tentaculo = $Tentaculo
@onready var linea = $Tentaculo/Linea
@onready var area = $Tentaculo/Area2D
@onready var forma = $Tentaculo/Area2D/CollisionShape2D
 
var ventosas: Node2D
var puntos := PackedVector2Array()
var ataque_listo := true
var atacando := false
var siguiendo := false
var longitud := 0.0
var onda := 1.0
var tiempo := 0.0
 
func _ready():
	forma.shape = RectangleShape2D.new()
	linea.width = grosor
	linea.begin_cap_mode = Line2D.LINE_CAP_ROUND
	linea.end_cap_mode = Line2D.LINE_CAP_ROUND
 
	var curva = Curve.new()
	curva.add_point(Vector2(0, 1.0))
	curva.add_point(Vector2(1, 0.25))
	linea.width_curve = curva
 
	var degradado = Gradient.new()
	degradado.set_color(0, Color("6A2C91"))
	degradado.set_color(1, Color("D58BE0"))
	linea.gradient = degradado
 
	ventosas = Node2D.new()
	tentaculo.add_child(ventosas)
	ventosas.draw.connect(dibujar_ventosas)
 
func _process(delta):
	tiempo += delta
	var lumi = get_tree().get_first_node_in_group("Lumi")
 
	if ataque_listo and lumi and tentaculo.global_position.distance_to(lumi.global_position) < radio_deteccion:
		atacar()
 
	if lumi and (siguiendo or atacando):
		var giro = 5.0 if siguiendo else giro_golpe
		var objetivo = (lumi.global_position - tentaculo.global_position).angle()
		tentaculo.rotation = lerp_angle(tentaculo.rotation, objetivo, giro * delta)
 
	if atacando:
		for body in area.get_overlapping_bodies():
			if body.name == "Lumi":
				body.recibir_dano()
	actualizar()
 
func actualizar():
	var n := 16
	puntos = PackedVector2Array()
	for i in range(n):
		var f = float(i) / (n - 1)
		var y = sin(tiempo * 8.0 - f * 6.0) * 10.0 * f * onda
		puntos.append(Vector2(longitud * f, y))
	linea.points = puntos
	forma.shape.size = Vector2(max(longitud, 1.0), grosor)
	forma.position = Vector2(longitud / 2.0, 0)
	ventosas.queue_redraw()
 
func dibujar_ventosas():
	for i in range(2, puntos.size() - 1, 2):
		var f = float(i) / puntos.size()
		ventosas.draw_circle(puntos[i], lerp(6.0, 2.0, f), Color("F2B6E8"))
 
func atacar():
	ataque_listo = false
	Audio.sfx_cerca("pulpo_ataque", tentaculo.global_position, 800.0)
	siguiendo = true
	onda = 1.0
	linea.modulate = Color(1.0, 0.75, 0.75)
 
	var subir = create_tween()
	subir.tween_property(self, "longitud", largo_aviso, 0.3)
	subir.tween_interval(tiempo_aviso)
	await subir.finished
 
	siguiendo = false
	linea.modulate = Color(1.0, 0.4, 0.4)
	await get_tree().create_timer(tiempo_fijo).timeout
 
	onda = onda_golpe
	atacando = true
	linea.modulate = Color.WHITE
	var golpe = create_tween()
	golpe.tween_property(self, "longitud", alcance, 0.1)
	golpe.tween_interval(0.7)
	golpe.tween_property(self, "longitud", 0.0, 0.4)
	await golpe.finished
 
	atacando = false
	await get_tree().create_timer(descanso).timeout
	ataque_listo = true
