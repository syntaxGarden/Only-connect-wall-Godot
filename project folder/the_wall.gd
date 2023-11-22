extends Node2D

#Load the button scene for instancing
var buttonScene : PackedScene = preload("res://wallButton.tscn") 

var answers 
var connections 
var buttons = []
var clicked = []
var solved = []
var solved_answers = []
var total_solved = 0
var tries_left = 3

func _ready():
	$AnimationPlayer.play("timer") #Later possibly add an option to turn ff the time limit and the 3 tries
	$buttonArea.visible = false
	$"/root/Global".game_state = 0
	$"/root/Global".solved = []
	$"/root/Global".total_solved = 0
	#Add all of the button scene instances
	#Step 1: set the answers and connection names
	#Step 2: randomise the positions of the buttons
	#Step 3: create the button nodes with the data 
	#Step 4: move end game nodes in front of buttons
	
	#Step 1: Import the answer and connection data 
	answers = $"/root/Global".wall_answers
	connections = $"/root/Global".wall_connections
	
	#Step 2: Randomise the positions for the buttons
	#SHOULD make this better later by elimating situations where the code places more than 2 buttons of the same connection together. But for now, this is good enough
	var positions = []
	var pos = Vector2.ZERO
	for i in 4: #Horizontal
		for j in 4: #Vertical
			pos.x = 140 + (188*j)
			pos.y = 35 + (114*i)
			positions.push_back(pos)
	randomize()
	positions.shuffle()
	
	#Step 3: Create the actual button scenes 
	var buttonInstance
	for i in 4: #Horizontal
		for j in 4: #Vertical
			buttonInstance = buttonScene.instance()
			buttonInstance.set_pos(positions[4*i+j])
			buttonInstance.set_answer(answers[4*i+j])
			buttonInstance.set_ID(4*i+j)
			add_child(buttonInstance)
			buttons.push_back(buttonInstance)
	
	#Step 4: move end game nodes in front of buttons
	var tree_pos = buttons[15].get_position_in_parent()
	move_child($end_fade, tree_pos)

func game_process():
	var testID = $"/root/Global".clickID
	var testState = $"/root/Global".clickState
	if testID != -1:             #If something is clicked
		#print("\nSomething is clicked")
		if testState: #If being clicked
			clicked.push_back(testID)
			#print("Button " + str(testID) + " ON")
		else: #If being unclicked
			clicked.erase(testID)
			#print("Button " + str(testID) + " OFF")
			
		if len(clicked) == 4: #If completed
			#print("4 have been pressed")
			#If all buttons are 
			var cond0_1 = (clicked[0] / 4) == (clicked[1] / 4) 
			var cond1_2 = (clicked[1] / 4) == (clicked[2] / 4)
			var cond2_3 = (clicked[2] / 4) == (clicked[3] / 4)
			if cond0_1 and cond1_2 and cond2_3: #If right answer, solve all of the buttons and have them move
				#print("The 4 matched up")
				total_solved += 1
				if total_solved == 2:
					$tries.visible = true
				
				for i in 4:
					buttons[clicked[i]].solve(i,total_solved)
					solved_answers.push_back(clicked[0])
				solved.push_back(clicked[0] / 4)
				
				#If it was of the final 2 to solve, then mark all for solve
				if total_solved == 3:
					for i in 16:
						if !(i in solved_answers):
							buttons[i].solve(i,total_solved)
					$"/root/Global".game_state = 1
					$end_fade.visible = true
					$end_fade/solved.visible = true
					$AnimationPlayer.stop()
				
				#Reshuffling step [NEEDS FINISHING]
				if total_solved == 3: #Solve every last one
					pass
				else: #If normal solving
					pass
			
			else: #If wrong answer, unclick all of the buttons
				#print("The 4 DIDN'T match up")
				#Play wrong answer noise
				for i in 4:
					buttons[clicked[i]].click()
				if total_solved == 2:
					#Reduce number of tries
					get_node(NodePath("tries/"+str(tries_left))).visible = false
					tries_left -= 1
					if tries_left == 0:
						$"/root/Global".game_state = 2
						$end_fade.visible = true
						$end_fade/frozen.visible = true
						$AnimationPlayer.stop()
			
			clicked.clear() #Clear the array at the end for the the next clicked buttons
			#print("End of click")
			
		#Reset the click variables after the click has been processed
		$"/root/Global".clickID = -1
		$"/root/Global".clickState = false

#game_state will be:
#~0 if the game is still going
#~1 if the game is solved
#~2 if the game is lost

func _process(delta):
	if Input.is_action_just_pressed("go_back"):
		get_tree().change_scene("res://main_menu.tscn")
	if $"/root/Global".game_state == 0: #Game still playing
		game_process()
	elif $"/root/Global".game_state == 1 or $"/root/Global".game_state == 2: #Game is finished
		if Input.is_action_just_pressed("confirm"):
			$"/root/Global".solved = solved
			$"/root/Global".total_solved = total_solved
			get_tree().change_scene("res://answers.tscn")
	else:
		$"/root/Global".FATALERROR = "FATAL ERROR: wall code process had unknown game state"
		get_tree().change_scene("res://FATALERROR.tscn")

func _on_AnimationPlayer_animation_finished(anim_name):
	#When the timer finishes, flash up the game over sign because the wall wasn't solved 
	$"/root/Global".game_state = 2
	$end_fade.visible = true
	$end_fade/frozen.visible = true

func _on_audio_finished():
	$audio.play()
