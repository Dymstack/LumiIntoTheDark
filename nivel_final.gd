extends Node2D

var cinematica_iniciada := false

func _ready() -> void:
	if has_node("HUD"):
		$HUD.mostrar_boton_linterna(true)

	var lumi = get_tree().get_first_node_in_group("Lumi")
	if lumi and lumi.has_method("encender_luz_laberinto"):
		lumi.encender_luz_laberinto()

	$Fundido/Negro.modulate.a = 0.0
	$Fundido/Texto.modulate.a = 0.0
	$Fundido/Creditos.modulate.a = 0.0
	$ZonaCinematica.body_entered.connect(_on_zona_cinematica_body_entered)

func _on_zona_cinematica_body_entered(body):
	if body.name == "Lumi" and not cinematica_iniciada:
		cinematica_iniciada = true
		iniciar_cinematica(body)

func iniciar_cinematica(lumi):
	lumi.automatico = true
	lumi.velocity = Vector2.ZERO
	$HUD/Joystick.visible = false
	$HUD.mostrar_boton_linterna(false)

	var luz = lumi.get_node("LuzLinterna")
	var t = create_tween()
	var rot_destino = lumi.rotation + angle_difference(lumi.rotation, PI)
	t.tween_property(lumi, "rotation", rot_destino, 1.0)
	t.parallel().tween_property(luz, "energy", 1.8, 1.0)
	t.parallel().tween_property(luz, "texture_scale", 2.2, 1.0)
	t.parallel().tween_property(lumi, "global_position", Vector2(360, 1050), 16.0)

	var f = create_tween()
	f.tween_interval(8.0)
	f.tween_property($Fundido/Negro, "modulate:a", 1.0, 8.0)
	f.tween_property($Fundido/Texto, "modulate:a", 1.0, 2.0)
	f.tween_interval(3.0)
	f.tween_property($Fundido/Texto, "modulate:a", 0.0, 1.5)
	f.tween_property($Fundido/Creditos, "modulate:a", 1.0, 2.0)
	f.tween_interval(5.0)
	f.tween_property($Fundido/Creditos, "modulate:a", 0.0, 2.0)
	f.tween_interval(1.0)
	f.tween_callback(volver_al_menu)
	
func volver_al_menu() -> void:
	Global.vidas = 3
	get_tree().change_scene_to_file("res://menu_principal.tscn")
