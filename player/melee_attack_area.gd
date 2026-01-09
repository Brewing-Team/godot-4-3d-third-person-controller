extends Area3D

@onready var collision_shape: CollisionShape3D = $CollisionShape3d



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


func activate():
	collision_shape.set_deferred("disabled", false)


func deactivate():
	collision_shape.set_deferred("disabled", true)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("damageables"):
		var parent_node := get_parent().get_parent()  # Get Player node
		var impact_point: Vector3 = parent_node.global_position - body.global_position
		var force := -impact_point.normalized() * 10.0
		body.damage(impact_point, force)
		
		# Get enemy_id if body is an enemy
		var hit_enemy_id := -1
		if body.has_method("get_enemy_id"):
			hit_enemy_id = body.get_enemy_id()
		
		GDInsightAPI.data_sender.on_player_attack.emit(
			50,
			impact_point,
			-impact_point.normalized(),
			GDInsightAPI.data_sender.ATTACK_TYPE.MELEE,
			hit_enemy_id
		)
