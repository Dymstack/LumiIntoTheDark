extends Node

const RUTA_SFX := "res://Audio/sfx/"
const RUTA_MUSICA := "res://Audio/Musica/"
const EXTENSIONES := [".wav", ".ogg", ".mp3"]

# Qué música suena en cada escena (archivo .tscn -> pista)
const MUSICA_POR_ESCENA := {
	"menu_principal.tscn": "menu",
	"nivel_prueba.tscn": "superficie",
	"nivel_2.tscn": "superficie",
	"nivel_3.tscn": "superficie",
	"laberinto.tscn": "profundidad",
	"nivel_5.tscn": "profundidad",
	"nivel_final.tscn": "profundidad",
}

const VOLUMEN_MUSICA_DB := -6.0
const FADE := 1.5

var _cache := {}
var _musica_a: AudioStreamPlayer
var _musica_b: AudioStreamPlayer
var _activo: AudioStreamPlayer
var _tween: Tween
var _pista_actual := ""
var _escena_actual := ""

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_musica_a = _crear_reproductor_musica()
	_musica_b = _crear_reproductor_musica()
	_activo = _musica_a

func _crear_reproductor_musica() -> AudioStreamPlayer:
	var p = AudioStreamPlayer.new()
	p.bus = "Musica"
	p.volume_db = -80.0
	add_child(p)
	return p

# Detecta el cambio de escena y cambia la música sola
func _process(_delta: float) -> void:
	var escena = get_tree().current_scene
	if escena == null:
		return
	var archivo = escena.scene_file_path.get_file()
	if archivo != _escena_actual:
		_escena_actual = archivo
		var pista = MUSICA_POR_ESCENA.get(archivo, "")
		if pista != "":
			musica(pista)

func _buscar(carpeta: String, nombre: String) -> AudioStream:
	var clave = carpeta + nombre
	if _cache.has(clave):
		return _cache[clave]
	for ext in EXTENSIONES:
		if ResourceLoader.exists(clave + ext):
			var s = load(clave + ext)
			_cache[clave] = s
			return s
	push_warning("Audio: no se encontró '%s'" % clave)
	_cache[clave] = null
	return null

func _con_loop(stream: AudioStream) -> AudioStream:
	if stream is AudioStreamOggVorbis or stream is AudioStreamMP3:
		stream.loop = true
	elif stream is AudioStreamWAV:
		stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
		stream.loop_begin = 0
		stream.loop_end = int(stream.get_length() * stream.mix_rate)
	return stream

func musica(nombre: String) -> void:
	if nombre == _pista_actual:
		return
	_pista_actual = nombre
	var stream = _buscar(RUTA_MUSICA, nombre) if nombre != "" else null
	var saliente = _activo
	_activo = _musica_b if _activo == _musica_a else _musica_a

	if _tween:
		_tween.kill()
	_tween = create_tween().set_parallel(true)
	_tween.tween_property(saliente, "volume_db", -80.0, FADE)
	if stream != null:
		_activo.stream = _con_loop(stream)
		_activo.volume_db = -80.0
		_activo.play()
		_tween.tween_property(_activo, "volume_db", VOLUMEN_MUSICA_DB, FADE)
	_tween.chain().tween_callback(saliente.stop)

func sfx(nombre: String, volumen_db := 0.0, pitch := 1.0) -> void:
	var stream = _buscar(RUTA_SFX, nombre)
	if stream == null:
		return
	var p = AudioStreamPlayer.new()
	p.stream = stream
	p.bus = "SFX"
	p.volume_db = volumen_db
	p.pitch_scale = pitch
	add_child(p)
	p.finished.connect(p.queue_free)
	p.play()

# Suena más fuerte cuanto más cerca está el origen de Lumi
func sfx_cerca(nombre: String, origen: Vector2, alcance := 700.0, volumen_db := 0.0, pitch := 1.0) -> void:
	var lumi = get_tree().get_first_node_in_group("Lumi")
	if lumi == null:
		return
	var f = clampf(1.0 - origen.distance_to(lumi.global_position) / alcance, 0.0, 1.0)
	if f < 0.03:
		return
	sfx(nombre, volumen_db + linear_to_db(f), pitch)
