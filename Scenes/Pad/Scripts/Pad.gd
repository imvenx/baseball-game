extends Node2D

onready var hitBallSound:AudioStreamPlayer = get_child(4)

#func _ready():
#	Arcane.signals.addSignal('hitBall')
#	Arcane.signals.connect("hitBall", self, 'onHitBall')

func _on_CalibrateQuaternion_pressed():
	Arcane.pad.calibrateQuaternion()


#func onHitBall(e, from):
#	Arcane.utils.writeToScreen("asd")
#	hitBallSound.play()
