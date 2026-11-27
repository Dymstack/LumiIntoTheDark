extends Area2D
 
@export var escena_destino: PackedScene
 
func _on_body_entered(body):
	if body.name == "Lumi" and escena_destino != null:
		Audio.sfx("transicion")
		get_tree().call_deferred("change_scene_to_packed", escena_destino)
