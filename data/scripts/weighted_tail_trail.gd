extends Line2D
class_name StiffTrails

var trail_max_length : int = 7
var min_move_distance : float = 0.5
var stiffness_length : int = 1  # Number of stiff points at head
var f_gen_vector_x_separation : int = 6
var orientation : String = "right" : set = set_orientation
var trail_queue : Array[Vector2] = []
var last_recorded_pos : Vector2 = Vector2.INF
var current_pos : Vector2
var initialized : bool = false
var offset : Vector2
var flex_offset : Vector2
var util_position : Vector2

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout #Crear un timer para dar tiempo a que la nave del jugador se acomodo bien antes de que ejecutemos cualquier cosa
	#if not IntermediarySettingsManager.simplified_ship_trails_state:
		#initialized = true
	initialized = true

func _physics_process(_delta: float) -> void:
	if not initialized:
		return

	current_pos = _get_util_position()
	trail_queue.push_front(current_pos)

	if trail_queue.size() > trail_max_length + stiffness_length:
		trail_queue.pop_back()
	
	update_line()

func update_line() -> void:
	clear_points()
	
	# Add all points, but only first 'stiffness_length' points will appear stiff
	for i in trail_queue.size():
		# Apply stiffness effect only to first few points
		if i < stiffness_length:
			var base_pos = trail_queue[0]  # Base position (head)
			offset = Vector2(f_gen_vector_x_separation * i * orientation_sign(), 0)
			add_point(base_pos + offset)
		else:
			flex_offset = Vector2(f_gen_vector_x_separation * i * orientation_sign(), 0)
			add_point(trail_queue[i] + flex_offset)
			

func orientation_sign() -> float:
	return -1.0 if orientation == "right" else 1.0

func _get_util_position() -> Vector2:
	return get_parent().get_parent().global_position + util_position

func _set_util_position(value : Vector2) -> void:
	util_position = value
	
func _set_trail_max_length(value : int) -> void:
	trail_max_length = value

func set_orientation(new_orientation: String) -> void:
	if orientation != new_orientation:
		orientation = new_orientation
		reset_trail()

func reset_trail() -> void:
	trail_queue.clear()
	
func set_visibility(state_val : bool) -> void:
	visible = state_val

func get_visibility() -> bool:
	if visible:
		return true
	else:
		return false
