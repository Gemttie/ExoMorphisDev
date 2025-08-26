extends Area2D

@export var damage : int = 1
@export var veloc : Vector2 = Vector2(1300.0, 0.0)

func _on_area_entered(area: Area2D) -> void:
	var area_parent = area.get_parent()
	if area_parent.is_in_group("damageable_enemy"):
		if area_parent.has_method("take_damage"):
			area_parent.take_damage(damage)
		else: 
			push_warning(str(area_parent) + " doesnt have the method take_damage()")

func _process(delta: float) -> void:
	position += veloc * delta	
