extends Node


var pad:ArcanePad
var padQuaternion = Quat()
onready var bonkSound:AudioStreamPlayer3D = get_child(2)

func initialize(_pad:ArcanePad) -> void:
	
	prints("Pad user", _pad.user.name, "initialized")
	pad = _pad
	
	pad.startGetQuaternion()
	
	# warning-ignore:RETURN_VALUE_DISCARDED
	pad.connect(AEventName.GetQuaternion, self, 'onGetQuaternion')
	
	
func _process(_delta):
	self.transform.basis = Basis(padQuaternion)


func _exit_tree():
	pad.queue_free()
	
	
func onGetQuaternion(q):
	padQuaternion.x = -q.x
	padQuaternion.y = -q.y
	padQuaternion.z = q.z
	padQuaternion.w = q.w
	
	
func onOpenArcaneMenu(_e):
	print('Menu opened by ', pad.user.name)
	
func onCloseArcaneMenu(_e):
	print('Menu closed by ', pad.user.name)
	
	
func _on_Bat_body_entered(_body):
	pad.vibrate(80)
	bonkSound.play()
