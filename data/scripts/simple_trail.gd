extends Line2D

@export var min_distance := 1.0
@export var trail_width := 6.0
@export var delete_delay := 0.02  # seconds between each point deletion

var prev_pos: Vector2
var curr_pos: Vector2
var delete_timer := 0.0


func _ready() -> void:
	width = trail_width
	prev_pos = get_parent().global_position


func _process(delta: float) -> void:
	curr_pos = get_parent().global_position

	#add a new point if moved far enough
	if prev_pos.distance_to(curr_pos) > min_distance:
		add_point(curr_pos)
		prev_pos = curr_pos

	if points.size() > 30:
		remove_point(0)
	
	delete_timer += delta
	if delete_timer >= delete_delay and points.size() > 0:
		remove_point(0)
		delete_timer = 0.0
