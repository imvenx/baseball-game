extends Node2D

onready var hitBallSound:AudioStreamPlayer = get_child(4)

func _ready():
	initPad()
	
	
func initPad():
	Arcane.init({'deviceType': 'pad'})
	

func _on_CalibrateQuaternion_pressed():
	Arcane.pad.calibrateQuaternion()

