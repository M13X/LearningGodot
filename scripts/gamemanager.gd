extends Node

# Imports
@onready var score_label = $ScoreLabel

# Variables
var score = 0


func add_point():
	score += 1
	score_label.text = "You got only " + str(score) + " coins. Disappointment!"
