extends Node
var pause_enabled : bool = true #Si es posible pausar el juego en este momento
var last_game_time_scale : float = 1.0 #En caso se haga pausa durante un slow motion o algo
var pause_type : String = "simple" #tipo de pause y segun eso mostrar un menu de pause u otro
var pause_state : bool #si el juego esta "paused" o "not_paused"
#@onready var simple_pause_menu_scene: PackedScene = preload("res://data/scenes/simple_pause_menu.tscn")
@onready var simple_pause_menu_scene: PackedScene
#AWAITING FOR A PAUSE MENU HERE

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause_action") and pause_enabled:
		if pause_state:
			pause_state = false
			unpause_the_game()
			
		else:
			pause_state = true
			pause_the_game()

func pause_the_game():
	if not pause_enabled:
		return
	
	last_game_time_scale = Engine.time_scale
	get_tree().paused = true
	SoundManager.pause_all_sounds()
	
	var pause_layer = get_tree().current_scene.get_node_or_null("pause_menu_layer")
	if pause_layer.has_node("black_translucent_rect"):
		var pause_layer_tr = pause_layer.get_node("black_translucent_rect")
		pause_layer_tr.visible = true
	
	#pausa simple
	if pause_type == "simple":
		generate_simple_pause_menu()
	
	print("Juego pausado")
	#hacer sonar la cancion de pause
	SoundManager.play_sound("pause_menu_calm_dark_theme_01", "menu_music")
	
func unpause_the_game():
	if not pause_enabled:
		return

	Engine.time_scale = last_game_time_scale
	get_tree().paused = false
	SoundManager.stop_specific_sound("pause_menu_calm_dark_theme_01", "menu_music")
	SoundManager.unpause_all_sounds()
	
	var pause_layer = get_tree().current_scene.get_node_or_null("pause_menu_layer")
	if pause_layer: 
		clear_all_pause_menus(pause_layer)
		if pause_layer.has_node("black_translucent_rect"):
			var pause_layer_tr = pause_layer.get_node("black_translucent_rect")
			pause_layer_tr.visible = false

	print("Juego resumido")
	
func clear_all_pause_menus(pause_layer):
	for child in pause_layer.get_children():
		if child.name != "black_translucent_rect":
			child.queue_free()

func generate_simple_pause_menu() -> void:
	var simple_pause_menu_instance = simple_pause_menu_scene.instantiate()
	var pause_layer = get_tree().current_scene.get_node_or_null("pause_menu_layer")
	pause_layer.add_child(simple_pause_menu_instance)
