extends Node2D

#Size = 180 and 116
#Label pos = -90 and -53
#Sprite pos = 236/788 and 464

var current_state = 0
var mouse_pos

func _process(delta):
	if current_state == 0:
		mouse_pos = get_local_mouse_position()
		if (464-53) < mouse_pos.y and mouse_pos.y < (464+53):
			if (236-90) < mouse_pos.x and mouse_pos.x < (236+90):
				$main/hovering.text = "play"
				if Input.is_action_just_pressed("mouse_click"):
					current_state = 1
					$main.visible = false
					$play.visible = true
			elif (512-90) < mouse_pos.x and mouse_pos.x < (512+90):
				$main/hovering.text = "custom"
			elif (788-90) < mouse_pos.x and mouse_pos.x < (788+90):
				$main/hovering.text = "close"
				if Input.is_action_just_pressed("mouse_click"):
					get_tree().quit()
			else:
				$main/hovering.text = "Nothing"
		else:
			$main/hovering.text = "Nothing"
	
	elif current_state == 1: #If on the stating screen
		if Input.is_action_just_pressed("confirm"):
			get_tree().change_scene("res://the_wall.tscn")
		if Input.is_action_just_pressed("go_back"):
			current_state = 0
			$main.visible = true
			$play.visible = false
