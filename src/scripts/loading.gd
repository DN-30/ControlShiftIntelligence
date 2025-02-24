extends Control

func rotate():
	$AnimationPlayer.play("rotate")

	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://src/scenes/world.tscn")
	


func _on_Timer_timeout():
	PlayerData.run_python_script()
	rotate()
