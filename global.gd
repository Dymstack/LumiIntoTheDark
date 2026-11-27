extends Node
 
var lumi_x = 360.0
var vidas = 3
 
# Reinicia sin sonido (se puede usar desde cualquier lado)
func reiniciar_partida() -> void:
	vidas = 3
	get_tree().call_deferred("change_scene_to_file", "res://nivel_prueba.tscn")

# Solo para cuando Lumi pierde la última vida
func derrota() -> void:
	Audio.sfx("derrota")
	reiniciar_partida()
