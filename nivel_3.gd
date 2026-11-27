extends Node2D

func _on_zona_fin_nivel_body_entered(body: Node2D) -> void:
	if body.is_in_group("Lumi") or body.name == "Lumi":
		Audio.sfx("transicion")
		get_tree().call_deferred("change_scene_to_file", "res://laberinto.tscn")
