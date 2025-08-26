extends CharacterBody2D

@onready var atomizer_t1_proyectile_scene : PackedScene = preload("res://data/scenes/atomizer_weapon_t1_proyectile.tscn")

@export_group("Base Stats")
@export var max_health: int = 30
@export var max_speed: float = 180.0
@export var tilt_angle: float = 5.0
@export var tilt_speed: float = 8.0

@export_group("Attack Stats")
@export var atomizer_shoot_cd : float = 0.14

@export_group("Trail and UX")
@export var weighted_tail_trail_1 : Line2D
@export var weighted_tail_trail_2 : Line2D
@export var weighted_tail_trail_3 : Line2D

var eq_weapons_loadout : Array[String] = ["", "", "", ""]   # always 4 slots
var weapon_dict : Dictionary = {
	"atomizer_t1" : preload("res://data/scenes/atomizer_weapon_t1_proyectile.tscn")
}

var loadout_slot_1_cd_active : bool = false

var current_health: int
var current_speed: float
var target_rotation
var vel_vector_input_dir: Vector2
var is_dead : bool = false

func _ready() -> void:
	current_health = max_health
	current_speed = max_speed
	
	# setup trails
	weighted_tail_trail_1._set_util_position(Vector2($weighted_genpoint.position + Vector2(0.0, 0.0)))
	weighted_tail_trail_1._set_trail_max_length(5)

	weighted_tail_trail_2._set_util_position(Vector2($weighted_genpoint.position + Vector2(-1.0, 5.0)))
	weighted_tail_trail_2._set_trail_max_length(8)

	weighted_tail_trail_3._set_util_position(Vector2($weighted_genpoint.position + Vector2(-1.0, 10.0)))
	weighted_tail_trail_3._set_trail_max_length(5)

	# give player a starter weapon
	eq_loadout_add_weapon("atomizer_t1", 0)
	assign_eq_loadout()


func _process(delta: float) -> void:
	# ✅ Safeguard: Input.get_axis() can return null if actions aren’t mapped
	var input_dir_x = Input.get_axis("left", "right")
	if input_dir_x == null:
		input_dir_x = 0.0
	var input_dir_y = Input.get_axis("up", "down")
	if input_dir_y == null:
		input_dir_y = 0.0

	vel_vector_input_dir = Vector2(input_dir_x, input_dir_y).normalized()
	velocity = vel_vector_input_dir * current_speed
	move_and_slide()

	# tilt
	target_rotation = 0.0
	if input_dir_y > 0:
		target_rotation = deg_to_rad(tilt_angle)
	elif input_dir_y < 0:
		target_rotation = deg_to_rad(-tilt_angle)
	rotation = lerp_angle(rotation, target_rotation, delta * tilt_speed)

	global_position.x = clamp(global_position.x, 16, 512 - 20)
	global_position.y = clamp(global_position.y, 6, 288 - 8)

	if Input.is_action_just_pressed("quaternary_action"):
		take_damage(2)

	# shoot
	if Input.is_action_pressed("primary_action"):
		if loadout_slot_1_cd_active: return
		else:
			loadout_slot_1_cd_active = true
			var atomizer_proyectile_t1_instance = atomizer_t1_proyectile_scene.instantiate()
			get_parent().get_parent().get_node_or_null("player_proyectile_layer").add_child(atomizer_proyectile_t1_instance)
			atomizer_proyectile_t1_instance.global_position = global_position + Vector2(4.0, 6.0)
			get_tree().create_timer(atomizer_shoot_cd).timeout.connect(_on_loadout_slot_1_cd_timer_timeout, CONNECT_ONE_SHOT)


func take_damage(damage_amount : int) -> void:
	current_health -= damage_amount
	if current_health <= 0:
		death_handler()

func death_handler() -> void:
	is_dead = true
	print("player is dead")
	queue_free()


# Places weapon in given slot. If slot is already occupied, the old weapon is simply replaced.
func eq_loadout_add_weapon(weapon_name: String, loadout_pos: int) -> void:
	if loadout_pos >= 0 and loadout_pos < eq_weapons_loadout.size():
		eq_weapons_loadout[loadout_pos] = weapon_name


# Instantiates weapons in slots based on dictionary
func assign_eq_loadout() -> void:
	for i in range(eq_weapons_loadout.size()):
		var weapon_name = eq_weapons_loadout[i]
		if weapon_name != "" and weapon_dict.has(weapon_name):
			var weapon_instance = weapon_dict[weapon_name].instantiate()
			add_child(weapon_instance)
			
			# offset slot positions (example positions)
			match i:
				0: weapon_instance.position = Vector2(4.0, 6.0)
				1: weapon_instance.position = Vector2(4.0, -6.0)
				2: weapon_instance.position = Vector2(-4.0, 6.0)
				3: weapon_instance.position = Vector2(4.0, 6.0)
				
func _on_loadout_slot_1_cd_timer_timeout() -> void:
	loadout_slot_1_cd_active = false
