extends Area2D

# Esto crea una casilla visual en el Inspector
@export var escena_destino: PackedScene

func _on_body_entered(body): # (Usa el nombre exacto de la función que ya tenías)
	if body.name == "Lumi" and escena_destino != null:
		# En lugar de "_to_file", usamos "_to_packed" para esta variable
		get_tree().call_deferred("change_scene_to_packed", escena_destino)
