extends Node2D

@export var mob_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func _on_start_timer_timeout():
	#print_debug("HERE")
	#$MobTimer.start()
#
#
#func _on_mob_timer_timeout():
	#var mob = mob_scene.instantiate()
	#var mob_spawn_loc = $MobPath/MobSpawnLocation
	#
	#mob_spawn_loc.progress_ratio = randf()
	#
	#var direction = mob_spawn_loc + PI / 2
	#
	#mob.position = mob_spawn_loc.position
	#
	#direction += randf_range(-PI / 4, PI / 4)
	#
	#mob.rotation = direction
	#
	#mob.linear_velocity = Vector2(randf_range(150.0, 250.0), 0.0).rotated((direction))
	
	#add_child(mob)
