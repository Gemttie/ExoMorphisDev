extends Node
#Este singleton congela los frames del juego brevemente para dar una mejor sensacion de impactos y golpes

var _active := false
var _queued_duration := 0.0
var _original_time_scale := 1.0

#valores ajustables
const FLASH_COLOR := Color(0.9, 0.9, 1.0) #azul suave
var max_flash_strength : float = 0.40 #opacidad del color maxima
const FLASH_FADE_TIME := 0.15  #fade de 150ms

#ejecutar por duraciones
func micro() -> void:  _request_hit_stop(0.016)  # 1 frame
func short() -> void:  _request_hit_stop(0.033)  # 2 frames
func long() -> void:   _request_hit_stop(0.05)   # 3 frames
func custom(ms: float, flash_strength: float) -> void:
	max_flash_strength = flash_strength
	_request_hit_stop(ms / 1000.0)

#================= El corazon y alma de este singleton :3 ================
func _request_hit_stop(duration: float) -> void:
	if PauseManager.pause_state : return #bug critico arreglado : para evitar pausas eternas
	if duration <= 0: return
	_queued_duration = max(_queued_duration, duration)
	if !_active: _execute_hit_stop()

func _execute_hit_stop() -> void:
	#que los servidores de fisicas sigan corriendo
	PhysicsServer2D.set_active(true)
	
	#hacer freeze al juego
	_active = true
	_original_time_scale = Engine.time_scale
	get_tree().paused = true
	Engine.time_scale = 0.0
	
	#feedback visual
	_spawn_vfx()
	
	#duracion
	if _queued_duration > 0:
		var timer := get_tree().create_timer(_queued_duration, true, false, true)
		await timer.timeout
	
	#restaurar el juego como era
	Engine.time_scale = _original_time_scale
	get_tree().paused = false
	_queued_duration = 0.0
	_active = false

#efectos visuales =================================================
func _spawn_vfx() -> void:
	var flash := ColorRect.new()
	#flash.process_mode = PROCESS_MODE_ALWAYS
	#flash.set_process(ColorRect.PROCESS_MODE_ALWAYS)
	#flash.process_mode = Node.PROCESS_MODE_ALWAYS
	flash.color = FLASH_COLOR
	flash.color.a = 0.0  # Start transparent
	flash.size = get_viewport().size
	flash.z_index = 1000  # Ensure it's on top
	get_tree().root.add_child(flash)
	
	#animacion de fade
	var tween := create_tween().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(flash, "color:a", max_flash_strength * 0.5, FLASH_FADE_TIME * 0.3)
	tween.tween_property(flash, "color:a", 0.0, FLASH_FADE_TIME * 0.7)
	tween.tween_callback(flash.queue_free)
