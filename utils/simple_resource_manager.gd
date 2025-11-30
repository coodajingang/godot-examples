[gd_scene load_steps=2 format=3 uid="uid://resource_manager_simple"]

[ext_resource type="Script" path="res://scripts/event_bus.gd" id="1_event_bus"]

[node name="ResourceManager" type="Node"]
script = preload("res://scripts/event_bus.gd")

func _ready() -> void:
    print("=== Simple Resource Manager ===")
    print("✓ Event bus loaded")

func get_stickman_texture() -> ImageTexture:
    # Simple stickman - 32x48 white
    var image := Image.create(32, 48, false, Image.FORMAT_RGBA8)
    image.fill(Color.TRANSPARENT)
    
    # Draw head
    for x in range(24, 40):
        for y in range(8, 16):
            var dist := Vector2(x - 32, y - 8).length()
            if dist <= 8:
                image.set_pixel(x, y, Color.WHITE)
    
    # Draw body
    for x in range(20, 44):
        for y in range(16, 32):
            image.set_pixel(x, y, Color.WHITE)
    
    # Draw legs
    for x in range(16, 20):
        for y in range(32, 48):
            image.set_pixel(x, y, Color.WHITE)
    
    # Draw arms
    for x in range(8, 24):
        for y in range(24, 32):
            image.set_pixel(x, y, Color.WHITE)
    
    return ImageTexture.create_from_image(image)

func get_gate_texture(operation: String) -> ImageTexture:
    # Simple gate - 80x120
    var colors := {"add": Color.GREEN, "subtract": Color.RED, "multiply": Color.BLUE, "divide": Color.ORANGE}
    var color := colors.get(operation, Color.GRAY)
    var image := Image.create(80, 120, false, Image.FORMAT_RGBA8)
    image.fill(color)
    
    # Draw frame
    for x in range(80):
        for y in range(120):
            if x < 4 or x > 76 or y < 4 or y > 116:
                image.set_pixel(x, y, Color.WHITE)
    
    # Draw symbol
    var symbol := ""
    match operation:
        "add": symbol = "+"
        "subtract": symbol = "-"
        "multiply": symbol = "×"
        "divide": symbol = "÷"
        _: symbol = "?"
    
    # Draw symbol in center
    for x in range(20, 60):
        for y in range(40, 80):
            if _is_symbol_pixel(x, y, symbol):
                image.set_pixel(x, y, Color.BLACK)
    
    return ImageTexture.create_from_image(image)

func _is_symbol_pixel(x: int, y: int, symbol: String) -> bool:
    # Simple symbol detection
    if symbol == "+":
        return (x >= 20 and x <= 60 and y >= 40 and y <= 80)
    elif symbol == "-":
        return (x >= 20 and x <= 60 and y >= 40 and y <= 80)
    elif symbol == "×":
        return (x >= 20 and x <= 60 and y >= 40 and y <= 80)
    elif symbol == "÷":
        return (x >= 20 and x <= 60 and y >= 40 and y <= 80)
    else:
        return false

func get_obstacle_texture(type: String) -> ImageTexture:
    # Simple obstacle - 40x40
    var colors := {"barrier": Color.GRAY, "spike": Color.DARK_GRAY, "enemy": Color.RED}
    var color := colors.get(type, Color.GRAY)
    var image := Image.create(40, 40, false, Image.FORMAT_RGBA8)
    image.fill(color)
    
    # Draw based on type
    match type:
        "barrier":
            _draw_barrier(image)
        "spike":
            _draw_spike(image)
        "enemy":
            _draw_enemy(image)
        _:
            _draw_default_obstacle(image)
    
    return ImageTexture.create_from_image(image)

func _draw_barrier(image: Image) -> void:
    # Gray barrier with stripes
    for x in range(40):
        for y in range(40):
            if (x + y) % 8 < 4:
                image.set_pixel(x, y, Color.DARK_GRAY)

func _draw_spike(image: Image) -> void:
    # Triangle spike
    var points := [
        Vector2i(20, 8),   # Top tip
        Vector2i(8, 40),   # Bottom left
        Vector2i(32, 40)   # Bottom right
    ]
    
    for x in range(40):
        for y in range(40):
            if _point_in_triangle(Vector2i(x, y), points):
                image.set_pixel(x, y, Color.DARK_GRAY)

func _draw_enemy(image: Image) -> void:
    # Red enemy with angry face
    for x in range(40):
        for y in range(40):
            if x >= 12 and x <= 28 and y >= 8 and y <= 32:
                image.set_pixel(x, y, Color.RED)
    
    # Eyes
    image.set_pixel(29, 14, Color.WHITE)
    image.set_pixel(35, 14, Color.WHITE)
    image.set_pixel(29, 14, Color.BLACK)
    image.set_pixel(35, 14, Color.BLACK)
    
    # Angry mouth
    for x in range(18, 30):
        image.set_pixel(x, 24, Color.BLACK)

func _draw_default_obstacle(image: Image) -> void:
    # Default gray obstacle
    for x in range(40):
        for y in range(40):
            image.set_pixel(x, y, Color.GRAY)

func _point_in_triangle(point: Vector2i, points: Array[Vector2i]) -> bool:
    var v0 := points[1] - points[0]
    var v1 := points[2] - points[0]
    var v2 := point - points[0]
    
    var dot00 := v0.x * v0.x + v0.y * v0.y
    var dot01 := v0.x * v1.x + v0.y * v1.y
    var dot02 := v0.x * v2.x + v0.y * v2.y
    
    var inv_denom := 1.0 / (dot00 * dot11 - dot01 * dot01)
    var u := (dot11 * dot02 - dot01 * dot12) * inv_denom
    var v := (dot00 * dot12 - dot01 * dot02) * inv_denom
    
    return (u >= 0) and (v >= 0) and (u + v <= 1)