extends Node

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	elif event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()