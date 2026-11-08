extends CharacterBody3D

@export var walk_speed: float = 5.0
@export var sprint_speed: float = 8.0
@export var gravity: float = 18.0
@export var camera_distance: float = 7.0
@export var camera_height: float = 4.0

var camera_pivot: Node3D

func _ready() -> void:
    _create_character()
    _create_camera()

func _create_character() -> void:
    var body_mesh := MeshInstance3D.new()
    var capsule := CapsuleMesh.new()
    capsule.radius = 0.45
    capsule.height = 1.8
    body_mesh.mesh = capsule
    body_mesh.position.y = 0.9
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color(0.25, 0.45, 0.9)
    body_mesh.material_override = mat
    add_child(body_mesh)

    var collision := CollisionShape3D.new()
    var shape := CapsuleShape3D.new()
    shape.radius = 0.45
    shape.height = 1.8
    collision.shape = shape
    collision.position.y = 0.9
    add_child(collision)

func _create_camera() -> void:
    camera_pivot = Node3D.new()
    camera_pivot.position = Vector3(0, camera_height, camera_distance)
    add_child(camera_pivot)

    var camera := Camera3D.new()
    camera.position = Vector3(0, 0, camera_distance)
    camera.look_at(Vector3(0, 1, 0), Vector3.UP)
    camera.current = true
    camera_pivot.add_child(camera)

func _physics_process(delta: float) -> void:
    var input_vector := Vector2(
        Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
        Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
    ).normalized()

    var direction := Vector3(input_vector.x, 0, input_vector.y)
    var speed := sprint_speed if Input.is_action_pressed("sprint") else walk_speed

    velocity.x = direction.x * speed
    velocity.z = direction.z * speed

    if not is_on_floor():
        velocity.y -= gravity * delta
    else:
        velocity.y = 0.0

    if direction.length() > 0.05:
        rotation.y = atan2(direction.x, direction.z)

    move_and_slide()
