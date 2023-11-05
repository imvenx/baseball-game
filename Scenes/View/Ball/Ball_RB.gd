extends RigidBody

var initX
var initY
var initZ

var linearVelocity = Vector3(1, 5, 15) 
#var angularVelocity = Vector3(15, 0, 5)

func _ready():
	initX = translation.x
	initY = translation.y
	initZ = translation.z

	start_position_loop()
	
	linear_velocity = linearVelocity
#	angular_velocity = angularVelocity

func start_position_loop():
	while true:
		yield(get_tree().create_timer(4.0), "timeout")  # wait for 5 seconds
		translation = Vector3(initX, initY, initZ)  # set the position to (0, 10, 0)
		linear_velocity = linearVelocity
#		angular_velocity = angularVelocity

