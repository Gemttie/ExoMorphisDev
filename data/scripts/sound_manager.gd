# SoundManager.gd
extends Node

#limitar cantidad de sonidos que se pueden reproducir a la vez
const MAX_SIMULTANEOUS_EXPLOSIONS := 6
const MAX_SIMULTANEOUS_DEATHS := 3
const MAX_SIMULTANEOUS_DETONATINGS := 3
const MAX_SIMULTANEOUS_DESTRUCTIONS := 3
const MAX_SIMULTANEOUS_WARNINGS := 5
const MAX_SIMULTANEOUS_PLAYER_ATTACKS := 8
const MAX_SIMULTANEOUS_ENEMY_SHOTS := 14
const MAX_SIMULTANEOUS_BG_MUSIC_THEMES := 4
const MAX_SIMULTANEOUS_MENU_MUSIC_THEMES := 3
const MAX_SIMULTANEOUS_UI_SOUNDS := 5

var active_explosion_count := 0
var active_death_count := 0
var active_detonating_count := 0
var active_destruction_count := 0
var active_warning_count := 0
var active_player_attack_count := 0
var active_enemy_shot_count := 0
var active_bg_music_theme_count := 0
var active_menu_music_theme_count := 0
var active_ui_sounds_count := 0

var is_sound_paused : bool = false

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS #hacer play a los sonidos por mas que la timescale y el get_tree() este pausado

#sonidos precargados
var sounds := {
	##---------------- EXPLOSIONS -------------------
	#"player_charged_shot_detonating_slow_sfx": {
		#"stream": preload("res://assets/audio/sfx/ships/Antonio ship/player_charged_proyectile_detonating_slow.wav"),
		#"volume_db": 10.0,
		#"pitch_scale": 1.0
	#},
	#"wicked_explosion_01_sfx": {
		#"stream": preload("res://assets/audio/sfx/common_sfx/explosions/wicked_explosion_01.wav"),
		#"volume_db": 18.0, #volumen, "0.0 = no aumento"
		#"pitch_scale": 1.0
	#},
	##---------------- EXPLOSIONS -------------------
	#
	##---------------- PLAYER ATTACKS -------------------
	#"machete_z_sfx_02": {
		#"stream": preload("res://assets/audio/sfx/zero/machete_z_sfx_02.mp3"),
		#"volume_db": -16.0,
		#"pitch_scale": 1.0
	#},
	##---------------- PLAYER ATTACKS -------------------
	#
	##---------------- ENEMY SHOTS -------------------
	#"yellow_beam_warmup_sfx_01": {
		#"stream": preload("res://assets/audio/sfx/ships/Yellow_enemy_ship/yellow_beam_warmup_sfx_01.wav"),
		#"volume_db": 0.0,
		#"pitch_scale": 1.0
	#},
	#"yellow_beam_generation_sfx_01": {
		#"stream": preload("res://assets/audio/sfx/ships/Yellow_enemy_ship/yellow_beam_generation_sfx_01.wav"),
		#"volume_db": 0.0,
		#"pitch_scale": 1.0
	#},
	#"yellow_beam_active_sfx_01": {
		#"stream": preload("res://assets/audio/sfx/ships/Yellow_enemy_ship/yellow_beam_active_sfx_01.wav"),
		#"volume_db": 0.0,
		#"pitch_scale": 1.0
	#},
	#"base_huge_enemy_ship_beam_warmup_sfx_01": {
		#"stream": preload("res://assets/audio/sfx/ships/Huge enemy ship/base_huge_enemy_ship_beam_warmup_sfx_01.wav"),
		#"volume_db": 0.0,
		#"pitch_scale": 1.0
	#},
	##---------------- ENEMY SHOTS -------------------
	
	# ----------------- BG MUSIC -------------------
	#"disclaimer_theme_01": {
		#"stream": preload("res://assets/audio/music/disclaimer_theme_01.mp3"),
		#"volume_db": 0.0,
		#"pitch_scale": 1.0
	#},
		#"title_theme": {
		#"stream": preload("res://assets/audio/music/title.mp3"),
		#"volume_db": 0.0,
		#"pitch_scale": 1.0
	#},
		#"theme_of_zero": {
		#"stream": preload("res://assets/audio/music/theme_of_zero.mp3"),
		#"volume_db": 0.0,
		#"pitch_scale": 1.0
	#},
	# ----------------- BG MUSIC -------------------
	
	## ----------------- DEATHS -------------------
	#"swarmer_death_sfx": {
		#"stream": preload("res://assets/audio/sfx/ships/Swarmer enemy ship/swarmer_enemy_ship_death.wav"),
		#"volume_db": 0.0,
		#"pitch_scale": 1.0
	#},
	## ----------------- DEATHS -------------------
	#
	##------------- DESTRUCTIONS --------------
	#"big_rock_destroyed_01_sfx": {
		#"stream": preload("res://assets/audio/sfx/common_sfx/destroy/big_rock_destroyed_sfx_01.wav"),
		#"volume_db": 2.0,
		#"pitch_scale": 0.9
	#},
	#"big_rock_destroyed_02_sfx": {
		#"stream": preload("res://assets/audio/sfx/common_sfx/destroy/big_rock_destroyed_sfx_01.wav"),
		#"volume_db": 0.0,
		#"pitch_scale": 1.2
	#},
	#"small_rock_destroyed_01_sfx": {
		#"stream": preload("res://assets/audio/sfx/common_sfx/destroy/big_rock_destroyed_sfx_01.wav"),
		#"volume_db": -2.5,
		#"pitch_scale": 1.5
	#},
	#"small_rock_destroyed_02_sfx": {
		#"stream": preload("res://assets/audio/sfx/common_sfx/destroy/big_rock_destroyed_sfx_01.wav"),
		#"volume_db": -5.0,
		#"pitch_scale": 1.8
	#},
	#"level_0_bg_music_theme_01": {
		#"stream": preload("res://assets/audio/music/level_0/Space_N0_v1.2.wav"),
		#"volume_db": 0.0,
		#"pitch_scale": 1.0
	#},
	## ------------- DESTRUCTIONS --------------
	#
	##---------------- WARNINGS ----------------
	#"laser_beam_warning_sfx_01": {
		#"stream": preload("res://assets/audio/sfx/warnings/laser_beam_warning_sfx_01.wav"),
		#"volume_db": 0.0,
		#"pitch_scale": 1.0
	#},
	##---------------- WARNINGS ----------------
	#
	## ----------------- UI -------------------
	#"menu_cursor_hover_sfx_01": {
		#"stream": preload("res://assets/audio/sfx/menu/menu_cursor_hover_sfx_01.mp3"),
		#"volume_db": -10.0,
		#"pitch_scale": 1.0
	#},
	#"menu_cursor_click_sfx_01": {
		#"stream": preload("res://assets/audio/sfx/menu/menu_cursor_click_sfx_01.mp3"),
		#"volume_db": -11.0,
		#"pitch_scale": 1.0
	#},
	#"start_new_game_button_click_sfx_01": {
		#"stream": preload("res://assets/audio/sfx/menu/start_new_game_button_click_sfx_01.mp3"),
		#"volume_db": -11.0,
		#"pitch_scale": 1.0
	#},
	## ----------------- UI -------------------
#
	#"small_shot_collision_sfx_05": {
		#"stream": preload("res://assets/audio/sfx/ships/Antonio ship/small_shot_collision_sfx_05.wav"),
		#"volume_db": -2.0,
		#"pitch_scale": 1.0
	#},
	#"pause_menu_calm_dark_theme_01":{
		#"stream": preload("res://assets/audio/music/pause_menu/pause_menu_calm_dark_theme_01.wav"),
		#"volume_db": 0.0,
		#"pitch_scale": 1.0
	#}
}

#crear AudioStreamPlayer2D de un solo uso y manejar contandores correspondientes
func play_sound(sound_name: String, sound_type: String, position: Vector2 = Vector2.ZERO, pitch_variation : float = 0.0 ,pitch_randomization : float = 0.0) -> void:
	#revisar que exista el sonido
	if not sounds.has(sound_name):
		push_warning("Sonido no encontrado: ", sound_name)
		return
	
	match sound_type:
		"detonating":
			if active_detonating_count >= MAX_SIMULTANEOUS_DETONATINGS:
				return
			active_detonating_count += 1
			
		"explosion":
			if active_explosion_count >= MAX_SIMULTANEOUS_EXPLOSIONS:
				return
			active_explosion_count += 1
			
		"death":
			if active_death_count >= MAX_SIMULTANEOUS_DEATHS:
				return
			active_death_count += 1
		
		"destruction":
			if active_destruction_count >= MAX_SIMULTANEOUS_DESTRUCTIONS:
				return
			active_destruction_count += 1
			
		"warning":
			if active_warning_count >= MAX_SIMULTANEOUS_WARNINGS:
				return
			active_warning_count += 1
			
		"player_attack":
			if active_player_attack_count >= MAX_SIMULTANEOUS_PLAYER_ATTACKS:
				return
			active_player_attack_count += 1
			
		"enemy_shot":
			if active_enemy_shot_count >= MAX_SIMULTANEOUS_ENEMY_SHOTS:
				return
			active_enemy_shot_count += 1
			
		"bg_music":
			if active_bg_music_theme_count >= MAX_SIMULTANEOUS_BG_MUSIC_THEMES:
				return
			active_bg_music_theme_count += 1
			
		"menu_music":
			if active_menu_music_theme_count >= MAX_SIMULTANEOUS_MENU_MUSIC_THEMES:
				return
			active_menu_music_theme_count += 1
			
		"ui_sounds":
			if active_ui_sounds_count >= MAX_SIMULTANEOUS_UI_SOUNDS:
				return
			active_ui_sounds_count += 1
		_:
			push_warning("Tipo de sonido desconocido: ", sound_type)
			return

	#crear audio player
	var audio_player := AudioStreamPlayer2D.new()
	audio_player.stream = sounds[sound_name]["stream"] 
	audio_player.volume_db = sounds[sound_name]["volume_db"]
	
	#aumento o decremento de pitch
	audio_player.pitch_scale = sounds[sound_name]["pitch_scale"] + pitch_variation
	#variacion de pitch randomizada
	if pitch_randomization > 0.0:
		var randomized_pitch = snappedf(randf_range(audio_player.pitch_scale - pitch_randomization, audio_player.pitch_scale + pitch_randomization), 0.01)
		audio_player.pitch_scale = randomized_pitch
	
	audio_player.global_position = position
	
	#poner en un bus de sonido diferente dependiendo el el tipo de sonido que es
	match sound_type:
		"detonating", "explosion", "death", "destruction", "warning", "player_attack", "enemy_shot", "ui_sounds":
			audio_player.bus = "sfx"
		"bg_music", "menu_music":
			audio_player.bus = "music"
	
	#hacerle play
	audio_player.finished.connect(_on_sound_finished.bind(audio_player, sound_type))
	
	add_child(audio_player)
	audio_player.play()

func _on_sound_finished(player: AudioStreamPlayer2D, sound_type: String) -> void:
	player.queue_free()
	match sound_type:
		"detonating":
			active_detonating_count -= 1
		"explosion":
			active_explosion_count -= 1
		"death":
			active_death_count -= 1
		"destruction":
			active_destruction_count -= 1
		"warning":
			active_warning_count -= 1
		"player_attack":
			active_player_attack_count -= 1
		"enemy_shot":
			active_enemy_shot_count -= 1
		"bg_music":
			active_bg_music_theme_count -= 1
		"menu_music":
			active_menu_music_theme_count -= 1
		"ui_sounds":
			active_ui_sounds_count -= 1


#pausar todos los sonidos
func pause_all_sounds() -> void:
	if is_sound_paused:
		return
	
	is_sound_paused = true
	for child in get_children():
		if child is AudioStreamPlayer2D and child.playing:
			child.stream_paused = true

#despausar todos los sonidos
func unpause_all_sounds() -> void:
	if not is_sound_paused:
		return 
	
	is_sound_paused = false
	for child in get_children():
		if child is AudioStreamPlayer2D:
			child.stream_paused = false

#pausar sonidos especificos
func pause_sound_type(sound_type: String) -> void:
	for child in get_children():
		if child is AudioStreamPlayer2D and child.playing:
			match sound_type:
				"sfx":
					if child.bus == "sfx":
						child.stream_paused = true
				"music":
					if child.bus == "music":
						child.stream_paused = true

#despausar sonidos especificos
func unpause_sound_type(sound_type: String) -> void:
	for child in get_children():
		if child is AudioStreamPlayer2D:
			match sound_type:
				"sfx":
					if child.bus == "sfx":
						child.stream_paused = false
				"music":
					if child.bus == "music":
						child.stream_paused = false

#detener todos los sonidos completamente
func stop_all_sounds() -> void:
	for child in get_children():
		if child is AudioStreamPlayer2D:
			child.stop()
			child.queue_free()

	active_explosion_count = 0
	active_death_count = 0
	active_detonating_count = 0
	active_destruction_count = 0
	active_warning_count = 0
	active_player_attack_count = 0
	active_enemy_shot_count = 0
	active_bg_music_theme_count = 0
	active_ui_sounds_count = 0
	

#detener un sonido especifico
func stop_specific_sound(sound_name: String, sound_type: String) -> void:
	# Verify the sound exists in our dictionary
	if not sounds.has(sound_name):
		push_warning("Sonido no econtrado: ", sound_name)
		return
	
	var target_stream: AudioStream = sounds[sound_name]["stream"]
	var stopped_count := 0
	for child in get_children():
		if child is AudioStreamPlayer2D and child.stream == target_stream:
			if sound_type:
				var target_bus := "sfx" if sound_type in ["detonating", "explosion", "death", "destruction", "warning", "player_attack", "enemy_shot", "ui_sounds"] else "music"
				if child.bus != target_bus:
					continue
			
			child.stop()
			child.queue_free()
			stopped_count += 1
	
	#actualizar los counter
	if sound_type and stopped_count > 0:
		match sound_type:
			"detonating":
				active_detonating_count = max(0, active_detonating_count - stopped_count)
			"explosion":
				active_explosion_count = max(0, active_explosion_count - stopped_count)
			"death":
				active_death_count = max(0, active_death_count - stopped_count)
			"destruction":
				active_destruction_count = max(0, active_destruction_count - stopped_count)
			"warning":
				active_warning_count = max(0, active_warning_count - stopped_count)
			"player_attack":
				active_player_attack_count = max(0, active_player_attack_count - stopped_count)
			"enemy_shot":
				active_enemy_shot_count = max(0, active_enemy_shot_count - stopped_count)
			"bg_music":
				active_bg_music_theme_count = max(0, active_bg_music_theme_count - stopped_count)
			"menu_music":
				active_menu_music_theme_count = max(0, active_menu_music_theme_count - stopped_count)
			"ui_sounds":
				active_ui_sounds_count = max(0, active_ui_sounds_count - stopped_count)
