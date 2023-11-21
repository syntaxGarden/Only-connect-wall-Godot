extends Node

#This variable is for reporting fatal errors. The message goes here and the fata error scene will load it with _ready()
var FATALERROR = "The fatal error was not given a message"

#These variables are used to load the wall scene with answers and connections
var wall_answers = ["trafalgar","marshall","jaguar","rocks","fossil","flea","bloom","nut","balloons","mimicry","sleep","undefined","woman","byte","noir","ham"]
var wall_connections = ["Will of D surnames","DRG side objective","Clown corps routines","Spider___"]

#Determines if the buttons can be clicked at all during the animation
var can_click = true 

#These variables are use for the communication that something has been clicked
var clickID = -1
var clickState = false

#This logs what connections have been solved and is used in the results section of the game.
#The data is stored as integers of the positions in the wall_connections variable 
var solved = []
var total_solved = 0

#game_state will be:
#~0 if the game is still going
#~1 if the game is solved
#~2 if the game is lost
var game_state = 0
