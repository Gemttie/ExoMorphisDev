extends Node
#SOUND CONTROL, ESTE SINGLETON PERMITE REDUCIR E INCREMENTAR SUAVEMENTE EL AUDIO DE UN NODO AUDIOSTREAMPLAYER2D O AUDIOSTREAMPLAYER
#Ejm. de modo de uso: SoundControl.fade_out2D(main_menu_music_01, 2.0)

#----------------------------
#Para AudioStreamPlayer2D
#----------------------------
func fade_out2D(node: AudioStreamPlayer2D, duration: float = 1.0):
	var tween := get_tree().create_tween()
	tween.tween_property(node, "volume_db", -80, duration)
	tween.tween_callback(Callable(node, "stop"))

func fade_in2D(node: AudioStreamPlayer2D, duration: float = 1.0, volume_db: float = 0):
	node.play()  #iniciar antes del fade in
	node.volume_db = -80  # iniciar silencioso
	var tween := get_tree().create_tween()
	tween.tween_property(node, "volume_db", volume_db, duration)


#----------------------------
#Para AudioStreamPlayer
#----------------------------
func fade_out(node: AudioStreamPlayer, duration: float = 1.0):
	var tween := get_tree().create_tween()
	tween.tween_property(node, "volume_db", -80, duration)
	tween.tween_callback(Callable(node, "stop"))

func fade_in(node: AudioStreamPlayer, duration: float = 1.0, volume_db: float = 0):
	node.play()  #iniciar antes del fade in
	node.volume_db = -80  # iniciar silencioso
	var tween := get_tree().create_tween()
	tween.tween_property(node, "volume_db", volume_db, duration)
