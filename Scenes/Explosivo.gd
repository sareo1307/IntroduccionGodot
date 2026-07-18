extends CharacterBody3D


const SPEED = 0.5
const JUMP_VELOCITY = 1.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var mouse_sensivity = 0.003
@onready var camera3D =$Camera3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensivity)
		camera3D.rotate_x(-event.relative.y * mouse_sensivity)
		camera3D.rotation.x = clamp(camera3D.rotation.x, deg_to_rad(-60), deg_to_rad(70))

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
