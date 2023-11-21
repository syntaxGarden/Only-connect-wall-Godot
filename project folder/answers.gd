extends Node2D

var buttonScene : PackedScene = preload("res://wallButton.tscn") 

var wall_answers
var wall_connections
var solved_connections
var total_solved 

var not_solved_connections = []

var on_unsolved = false #Changed when going from solved to usolved connections
var current_connection = 0

func _ready():
	wall_answers = $"/root/Global".wall_answers
	wall_connections = $"/root/Global".wall_connections
	solved_connections = $"/root/Global".solved
	total_solved = $"/root/Global".total_solved

	print(solved_connections)
	print(total_solved)
	for i in 4:
		if !(i in solved_connections):
			not_solved_connections.append(i)
	if total_solved == 0:
		$header.text = "Unsolved connections"
		on_unsolved = true
	change_button_text()

func change_button_text():
	var button_text
	if on_unsolved:
		button_text = not_solved_connections[current_connection] * 4
		$connection/Label.text = wall_connections[not_solved_connections[current_connection]]
	else:
		button_text = solved_connections[current_connection]
		$connection/Label.text = wall_connections[solved_connections[current_connection]]
	for i in 4:
		get_node(NodePath(str(i))).set_answer(wall_answers[button_text + i])

func _process(delta):
	if Input.is_action_just_pressed("go_back"):
		get_tree().change_scene("res://main_menu.tscn")
	elif Input.is_action_just_pressed("confirm"):
		print("\n~Confirm Pressed")
		if $connection/Hider.visible: #If the answer is hidden (hider is visible), unhide
			$connection/Hider.visible = false
		else:                         #If the answer has been shown (hider is invisble), toggle to next answer
			current_connection += 1
			if on_unsolved and current_connection == len(not_solved_connections):
				#If on final unsolved connection, go to main menu
				get_tree().change_scene("res://main_menu.tscn")
			elif !on_unsolved and current_connection == len(solved_connections):
				current_connection = 0
				on_unsolved = true
				$header.text = "Unsolved connections"
				change_button_text()
			else:
				change_button_text()
			$connection/Hider.visible = true
