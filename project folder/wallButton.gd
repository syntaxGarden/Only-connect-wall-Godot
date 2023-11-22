extends Node2D

var clicked = false
var solved = false
var ID

func set_ID(value):
	ID = value

func get_ID():
	return ID

func set_answer(value):
	$text.text = value

func set_pos(value):
	position = value

func click():
	clicked = !clicked
	$"/root/Global".can_click = false
	#If clicking:   clicked = true,  speed = 1,  from_end = false
	#If unclicking: clicked = false, speed = -1, from_end = true
	$AnimationPlayer.play("clicked",-1, (-1 + 2*int(clicked)), !clicked)

var unclicking_from_wall_code = false
func unclick_from_wall_code():
	unclicking_from_wall_code = true
	$"/root/Global".can_click = false
	clicked = false
	$AnimationPlayer.play("clicked",-1, (-1 + 2*int(clicked)), !clicked)

var inArea = false
func _on_clickArea_mouse_entered():
	inArea = true

func _on_clickArea_mouse_exited():
	inArea = false

func solve(end_index, colour_index): #This activates the use of _animate() #NEEDS FINISHING
	solved = true
	$Sprite.visible = false

func get_solved():
	return solved

func move_button(): #This activates the use of _animate() #NEEDS FINISHING
	pass

var animating = false
func _animate(delta):
	animating = false 

#The variable useless is used when anwsers are shown during the show section
var useless = false
func render_useless():
	useless = true

func _process(delta):
	if !useless:
		if animating:
			_animate(delta)
		if !solved and $"/root/Global".game_state == 0: #If hasn't been solved yet and the game is still playable, can be interacted with. Otherwise, passes
			if Input.is_action_just_pressed("mouse_click") and inArea and $"/root/Global".can_click:
				click()

func _on_AnimationPlayer_animation_finished(anim_name): 
	#Only sends the signal of a clicked button once the animation has ended, but not if it's from a wrong answer
	if anim_name == "clicked" and not unclicking_from_wall_code:
		$"/root/Global".clickID = ID
		$"/root/Global".clickState = clicked
	$"/root/Global".can_click = true
