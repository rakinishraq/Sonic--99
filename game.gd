extends Node

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	elif event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()

func _physics_process(delta):
	var player_speed = round($Player.speed * 10) / 10.0
	$CanvasLayer/RichTextLabel1.set_text("Speed = " + str(player_speed))