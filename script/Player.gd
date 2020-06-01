extends KinematicBody

var mouse_sensitivity = 0.05

const CAMERA_X_ROT_MIN = -20
const CAMERA_X_ROT_MAX = 30

var camera_x_rot = 0.0

onready var mesh = $CollisionShape
onready var camera_base = $CameraBase
onready var camera_rot = $CameraBase/CameraRot

var cube

var direction = Vector3()
var velocity = Vector3()
var speed = 5
var acceleration = 3
var rotation_speed = 2
onready var label = $Label1

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):

	direction = Vector3()

	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	
	elif Input.is_action_pressed("move_back"):
		direction += transform.basis.z

	if Input.is_action_pressed("move_left"):
		direction += transform.basis.x

	elif Input.is_action_pressed("move_right"):
		direction -= transform.basis.x

	velocity = direction * speed
	velocity.linear_interpolate(velocity, acceleration * delta)

	velocity = move_and_slide(velocity, Vector3.UP)
		
func _input(event):

	if event is InputEventMouseMotion:
		rotate_camera(event.relative * mouse_sensitivity)

func rotate_camera(move):
	if velocity != Vector3.ZERO:
		rotate_y(-move.x)
	else:

		#PREMIER AXE (coté)
		camera_base.rotate_y(-move.x)
		camera_base.orthonormalize() # After relative transforms, camera needs to be renormalized.

		#DEUXIEME AXE (haut/bas)
		camera_x_rot -= move.y
		camera_x_rot = clamp(camera_x_rot, deg2rad(CAMERA_X_ROT_MIN), deg2rad(CAMERA_X_ROT_MAX))
		camera_rot.rotation.x = camera_x_rot
