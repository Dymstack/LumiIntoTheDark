extends PathFollow2D
 
@export var velocidad := 120.0
@export var radio_deteccion := 400.0
@export var velocidad_embestida := 700.0
@export var tiempo_aviso := 0.4
@export var descanso := 1.5
 
@onready var area = $Area2D
var embistiendo := false
var puede_embestir := true
var x_anterior := 0.0
 
func _process(delta):
	if not embistiendo:
		progress += velocidad * delta
		var dx = position.x - x_anterior
		if abs(dx) > 0.01:
			area.scale.x = -1 if dx < 0 else 1
		x_anterior = position.x
 
		var lumi = get_tree().get_first_node_in_group("Lumi")
		if puede_embestir and lumi and area.global_position.distance_to(lumi.global_position) < radio_deteccion:
			embestir(lumi.global_position)
 
	for body in area.get_overlapping_bodies():
		if body.name == "Lumi":
			body.recibir_dano()
func embestir(objetivo: Vector2):
	embistiendo = true
	puede_embestir = false
	var dir = objetivo - area.global_position
	var distancia = dir.length()
	var angulo = dir.angle()
	if dir.x < 0:
		area.scale.x = -1
		area.rotation = wrapf(angulo - PI, -PI, PI)
	else:
		area.scale.x = 1
		area.rotation = angulo
 
	var t = create_tween()
	t.tween_property(area, "modulate", Color(1, 0.4, 0.4), tiempo_aviso)
	t.tween_callback(func(): Audio.sfx_cerca("pez_espada_ataque", area.global_position, 800.0))
	t.tween_property(area, "global_position", objetivo, distancia / velocidad_embestida)
	t.tween_callback(volver)
 
func volver():
	embistiendo = false
	var t = create_tween()
	t.tween_property(area, "modulate", Color.WHITE, 0.2)
	t.parallel().tween_property(area, "position", Vector2.ZERO, area.position.length() / (velocidad_embestida * 0.6))
	t.parallel().tween_property(area, "rotation", 0.0, 0.3)
	await get_tree().create_timer(descanso).timeout
	puede_embestir = true
