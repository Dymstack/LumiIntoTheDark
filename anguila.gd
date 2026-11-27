extends Area2D
 
enum Tipo { IMPACIENTE, PACIENTE, CAZADORA }
 
@export var tipo: Tipo = Tipo.IMPACIENTE
@export var sentido := Vector2.LEFT
@export var distancia := 300.0
@export var asomo := 30.0
@export var salida_offset := 100.0
@export var mostrar_zona := false
@export var luz_color := Color(1.0, 0.75, 0.3)
@export var luz_intensidad := 0.9
@export var luz_largo := 800.0
@export var luz_alto := 200.0
 
var alcance_det := 300.0
var ancho := 90.0
var aviso := 0.4
var salida := 0.4
var afuera := 0.8
var descanso := 1.5
var listo := true
var activa := false
var inicio := Vector2.ZERO
var luz: PointLight2D
var prendida := false
 
func _ready():
	inicio = position
	$AnimatedSprite2D.play("salir")
	monitoring = false
	crear_luz()
	match tipo:
		Tipo.IMPACIENTE:
			alcance_det = 300.0
			ancho = 90.0
			aviso = 0.4
			salida = 0.4
			afuera = 0.8
			descanso = 1.5
		Tipo.PACIENTE:
			alcance_det = 450.0
			ancho = 70.0
			aviso = 1.5
			salida = 0.9
			afuera = 2.5
			descanso = 3.0
			distancia *= 1.4
		Tipo.CAZADORA:
			alcance_det = 400.0
			ancho = 150.0
			aviso = 1.0
			salida = 0.6
			afuera = 1.2
			descanso = 2.5
 
func crear_luz():
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
	luz.energy = 0.0
	luz.scale = Vector2(luz_largo / 256.0, luz_alto / 256.0)
	luz.position = sentido * luz_largo * 0.15
	add_child(luz)
 
func _draw():
	if mostrar_zona and listo:
		var k = absf(global_scale.x)
		draw_set_transform(sentido * salida_offset / k, sentido.angle(), Vector2.ONE / k)
		draw_rect(Rect2(0, -ancho, alcance_det, ancho * 2.0), Color(1, 0, 0, 0.2))
 
func _process(delta):
	if mostrar_zona:
		queue_redraw()
 
	var objetivo = 0.0
	if prendida:
		var salido = clampf(position.distance_to(inicio) / (distancia * 0.7), 0.0, 1.0)
		objetivo = luz_intensidad * salido * randf_range(0.5, 1.0)
	luz.energy = lerpf(luz.energy, objetivo, 15.0 * delta)
 
	var lumi = get_tree().get_first_node_in_group("Lumi")
	if listo and lumi and lumi_en_zona(lumi.global_position):
		emboscar(lumi)
 
	if activa:
		for body in get_overlapping_bodies():
			if body.name == "Lumi":
				body.recibir_dano()
func lumi_en_zona(punto: Vector2) -> bool:
	var k = absf(global_scale.x)
	var v = to_local(punto) * k - sentido * salida_offset
	var avance = v.dot(sentido)
	var lado = abs(v.dot(sentido.orthogonal()))
	return avance > -20.0 and avance < alcance_det and lado < ancho
 
func emboscar(lumi):
	listo = false
	prendida = true
	var dir = sentido.rotated(rotation)
	var largo = distancia
	if tipo == Tipo.CAZADORA:
		var hasta_lumi = (lumi.global_position - global_position).dot(dir)
		largo = clamp(hasta_lumi + 60.0, distancia * 0.4, distancia)
 
	var t = create_tween()
	t.tween_property(self, "position", inicio + dir * asomo, aviso)
	t.tween_callback(activar)
	t.tween_property(self, "position", inicio + dir * largo, salida)
	t.tween_interval(afuera)
	t.tween_property(self, "position", inicio, salida)
	t.tween_callback(desactivar)
	t.tween_interval(descanso)
	t.tween_callback(preparar)
 
func activar():
	Audio.sfx("anguila_sale")
	activa = true
	monitoring = true
 
func desactivar():
	activa = false
	prendida = false
	monitoring = false
 
func preparar():
	listo = true
 
func _on_body_entered(_body):
	pass
