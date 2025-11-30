[gd_scene load_steps=2 format=3 uid="uid://resource_manager_fixed"]

[ext_resource type="Script" path="res://scripts/event_bus.gd" id="1_event_bus"]

[ext_resource type="Script" path="res://scripts/game_manager.gd" id="1_game_manager"]
[ext_resource type="Script" path="res://scripts/level_manager.gd" id="1_level_manager"]
[ext_resource type="Script" path="res://scripts/stickman_squad.gd" id="1_stickman_squad"]
[ext_resource type="Script" path="res://scripts/stickman.gd" id="1_stickman"]
[ext_resource type="Script" path="res://scripts/math_gate.gd" id="1_math_gate"]
[ext_resource type="Script" path="res://scripts/obstacle.gd" id="1_obstacle"]
[ext_resource type="Script" path="res://scripts/ui_manager.gd" id="1_ui_manager"]
[ext_resource type="Script" path="res://utils/texture_generator.gd" id="1_texture_generator"]
[ext_resource type="Script" path="res://utils/sprite_sheet_generator.gd" id="1_sprite_sheet_generator"]
[ext_resource type="Script" path="res://utils/ui_texture_generator.gd" id="1_ui_texture_generator"]
[ext_resource type="Script" path="res://utils/asset_generator.gd" id="1_asset_generator"]
[ext_resource type="Script" path="res://utils/test_runner.gd" id="1_test_runner"]
[ext_resource type="Script" path="res://utils/verify_project.gd" id="1_verify_project"]
[ext_resource type="Script" path="res://utils/quick_status_check.gd" id="1_quick_status_check"]

[node name="ResourceManager" type="Node"]
script = preload("res://scripts/event_bus.gd")

func _ready() -> void:
    print("=== ResourceManager Initialized ===")
    
    # Load textures will be handled by individual scripts
    print("✓ Event bus loaded")
    print("✓ All scripts preloaded")
    print("✓ Ready to serve texture requests")

func get_stickman_texture() -> ImageTexture:
    # Simple fallback stickman
    var image := Image.create(64, 64, false, Image.FORMAT_RGBA8)
    image.fill(Color.TRANSPARENT)
    
    # Draw basic stickman
    _draw_stickman(image)
    
    return ImageTexture.create_from_image(image)

func _draw_stickman(image: Image) -> void:
    # Head
    for x in range(28, 36):
        for y in range(8, 16):
            image.set_pixel(x, y, Color.WHITE)
    
    # Body
    for x in range(24, 40):
        for y in range(16, 32):
            image.set_pixel(x, y, Color.WHITE)
    
    # Legs
    for x in range(20, 24):
        for y in range(32, 48):
            image.set_pixel(x, y, Color.WHITE)
    
    # Arms
    for x in range(12, 24):
        for y in range(16, 24):
            image.set_pixel(x, y, Color.WHITE)
    
    # Eyes
    image.set_pixel(29, 14, Color.BLACK)
    image.set_pixel(35, 14, Color.BLACK)

func get_gate_texture(operation: String) -> ImageTexture:
    var colors := {
        "add": Color.GREEN,
        "subtract": Color.RED,
        "multiply": Color.BLUE,
        "divide": Color.ORANGE
    }
    
    var color := colors.get(operation, Color.GRAY)
    var image := Image.create(80, 120, false, Image.FORMAT_RGBA8)
    image.fill(color)
    
    # Add white border
    for x in range(80):
        for y in range(120):
            if x == 0 or x == 79 or y == 0 or y == 119:
                image.set_pixel(x, y, Color.WHITE)
    
    # Add math symbol
    var symbol := ""
    match operation:
        "add": symbol = "+"
        "subtract": symbol = "-"
        "multiply": symbol = "×"
        "divide": symbol = "÷"
        _: symbol = "?"
    
    _draw_text_symbol(image, symbol, Vector2i(40, 60), Color.BLACK)
    
    return ImageTexture.create_from_image(image)

func _draw_text_symbol(image: Image, symbol: String, pos: Vector2i, color: Color) -> void:
    # Simple text drawing
    if symbol == "+":
        # Horizontal line
        for x in range(pos.x - 10, pos.x + 10):
            image.set_pixel(x, pos.y, color)
        # Vertical line
        for y in range(pos.y - 5, pos.y + 5):
            image.set_pixel(pos.x, y, color)
    elif symbol == "-":
        # Horizontal line
        for x in range(pos.x - 10, pos.x + 10):
            image.set_pixel(x, pos.y, color)
    elif symbol == "×":
        # Diagonal lines
        for i in range(-8, 9):
            image.set_pixel(pos.x + i, pos.y + i, color)
            image.set_pixel(pos.x + i, pos.y - i, color)
    elif symbol == "÷":
        # Horizontal line
        for x in range(pos.x - 10, pos.x + 10):
            image.set_pixel(x, pos.y, color)
        # Dots
        image.set_pixel(pos.x - 5, pos.y - 8, color)
        image.set_pixel(pos.x + 5, pos.y + 8, color)

func get_obstacle_texture(type: String) -> ImageTexture:
    var colors := {
        "barrier": Color.GRAY,
        "spike": Color.DARK_GRAY,
        "enemy": Color.RED,
        "zone": Color.ORANGE
    }
    
    var color := colors.get(type, Color.GRAY)
    var image := Image.create(48, 48, false, Image.FORMAT_RGBA8)
    image.fill(color)
    
    match type:
        "barrier":
            _draw_barrier(image)
        "spike":
            _draw_spike(image)
        "enemy":
            _draw_enemy(image)
        "zone":
            _draw_zone(image)
        _:
            _draw_default_obstacle(image)
    
    return ImageTexture.create_from_image(image)

func _draw_barrier(image: Image) -> void:
    # Gray barrier
    for x in range(48):
        for y in range(48):
            image.set_pixel(x, y, Color.GRAY)
    
    # Add warning stripes
    for i in range(0, 40, 8):
        for x in range(10, 38):
            image.set_pixel(x, y, Color.DARK_GRAY)

func _draw_spike(image: Image) -> void:
    # Triangle spike
    var points := [
        Vector2i(24, 8),   # Top tip
        Vector2i(8, 40),   # Bottom left
        Vector2i(40, 40)    # Bottom right
    ]
    
    # Fill triangle
    for x in range(8, 41):
        for y in range(8, 41):
            if _point_in_triangle(Vector2i(x, y), points):
                image.set_pixel(x, y, Color.DARK_GRAY)

func _draw_enemy(image: Image) -> void:
    # Red enemy with angry face
    for x in range(12, 8):
        for y in range(24, 40):
            image.set_pixel(x, y, Color.RED)
    
    # Eyes
    image.set_pixel(16, 14, 2, Color.WHITE)
    image.set_pixel(32, 14, 2, Color.WHITE)
    image.set_pixel(17, 15, 2, Color.BLACK)
    image.set_pixel(17, 15, 2, Color.BLACK)
    
    # Angry mouth
    for x in range(18, 30):
        image.set_pixel(x, y, Color.BLACK)

func _draw_zone(image: Image) -> void:
    # Danger zone with gradient
    for x in range(48):
        for y in range(48):
            var center_dist := Vector2(x, y).distance_to(Vector2(24, 24))
            var alpha := max(0.0, 1.0 - center_dist / 20.0)
            var pixel_color := Color(color.r, color.g, color.b, alpha * 0.7)
            image.set_pixel(x, y, pixel_color)

func _draw_default_obstacle(image: Image) -> void:
    # Default obstacle
    for x in range(48):
        for y in range(48):
            image.set_pixel(x, y, Color.GRAY)