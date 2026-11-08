extends Node3D

const PLAYER_SCENE_SCRIPT = preload("res://scripts/player.gd")

func _ready() -> void:
    _create_environment()
    _create_ground()
    _create_roads()
    _create_buildings()
    _create_player()
    _create_hud()

func _create_environment() -> void:
    var world := WorldEnvironment.new()
    var env := Environment.new()
    env.background_mode = Environment.BG_SKY
    env.sky = Sky.new()
    env.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
    env.ambient_light_energy = 0.8
    world.environment = env
    add_child(world)

    var sun := DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-55, -25, 0)
    sun.light_energy = 1.1
    sun.shadow_enabled = true
    add_child(sun)

func _make_box(parent: Node3D, size: Vector3, pos: Vector3, color: Color) -> MeshInstance3D:
    var mesh_instance := MeshInstance3D.new()
    var mesh := BoxMesh.new()
    mesh.size = size
    mesh_instance.mesh = mesh
    mesh_instance.position = pos
    var material := StandardMaterial3D.new()
    material.albedo_color = color
    material.roughness = 0.9
    mesh_instance.material_override = material
    parent.add_child(mesh_instance)
    return mesh_instance

func _create_ground() -> void:
    _make_box(self, Vector3(180, 0.3, 180), Vector3(0, -0.2, 0), Color(0.31, 0.58, 0.30))

func _create_roads() -> void:
    _make_box(self, Vector3(12, 0.08, 150), Vector3(0, -0.015, 0), Color(0.18, 0.19, 0.21))
    _make_box(self, Vector3(150, 0.08, 10), Vector3(0, -0.01, 0), Color(0.18, 0.19, 0.21))
    # Basit yol çizgileri
    for z in range(-65, 70, 10):
        _make_box(self, Vector3(0.25, 0.03, 4), Vector3(0, 0.04, z), Color(0.95, 0.88, 0.55))
    for x in range(-65, 70, 10):
        _make_box(self, Vector3(4, 0.03, 0.25), Vector3(x, 0.045, 0), Color(0.95, 0.88, 0.55))

func _create_buildings() -> void:
    var positions := [
        Vector3(-22, 0, -20), Vector3(22, 0, -20),
        Vector3(-22, 0, 20), Vector3(22, 0, 20),
        Vector3(-42, 0, -38), Vector3(42, 0, 38)
    ]
    var colors := [
        Color(0.88, 0.63, 0.43), Color(0.77, 0.82, 0.91),
        Color(0.91, 0.82, 0.56), Color(0.67, 0.78, 0.68),
        Color(0.79, 0.67, 0.84), Color(0.88, 0.76, 0.64)
    ]
    for i in range(positions.size()):
        var p: Vector3 = positions[i]
        var height := 7.0 + float(i % 3) * 2.0
        _make_box(self, Vector3(11, height, 10), p + Vector3(0, height / 2.0, 0), colors[i])
        _make_box(self, Vector3(11.5, 0.7, 10.5), p + Vector3(0, height + 0.35, 0), Color(0.28, 0.20, 0.17))
        # Ön cephede pencereler
        for wx in [-3.0, 3.0]:
            for wy in [2.5, 5.0]:
                if wy < height:
                    _make_box(self, Vector3(1.5, 1.5, 0.12), p + Vector3(wx, wy, -5.06), Color(0.55, 0.82, 0.95))

func _create_player() -> void:
    var player := CharacterBody3D.new()
    player.name = "Player"
    player.position = Vector3(0, 1.2, 8)
    player.set_script(PLAYER_SCENE_SCRIPT)
    add_child(player)

func _create_hud() -> void:
    var layer := CanvasLayer.new()
    add_child(layer)

    var label := Label.new()
    label.text = "YENİ HAYAT  |  İlk Sürüm"
    label.position = Vector2(22, 18)
    label.add_theme_font_size_override("font_size", 26)
    label.add_theme_color_override("font_color", Color(1, 1, 1))
    layer.add_child(label)

    var hint := Label.new()
    hint.text = "PC: WASD / Ok tuşları ile hareket"
    hint.position = Vector2(22, 56)
    hint.add_theme_font_size_override("font_size", 16)
    hint.add_theme_color_override("font_color", Color(1, 1, 1))
    layer.add_child(hint)

    var mobile_hint := Label.new()
    mobile_hint.text = "Mobil kontrol düğmeleri sonraki aşamada eklenecek."
    mobile_hint.position = Vector2(22, 82)
    mobile_hint.add_theme_font_size_override("font_size", 14)
    mobile_hint.add_theme_color_override("font_color", Color(1, 1, 1))
    layer.add_child(mobile_hint)
