extends Node

# Simplified Asset Generator - Creates all game assets
# This version uses basic drawing functions to avoid dependency issues

func _ready() -> void:
    print("=== Generating Math Runner Assets ===")
    
    # Create textures directory
    var dir := DirAccess.open("user://")
    if not dir.dir_exists("res://assets/textures"):
        DirAccess.open("res://").make_dir("assets/textures")
    
    # Generate all asset types
    _generate_character_assets()
    _generate_gate_assets()
    _generate_obstacle_assets()
    _generate_ui_assets()
    _generate_environment_assets()
    
    print("\n=== Asset Generation Complete ===")
    print("All textures have been saved to res://assets/textures/")
    print("You can now use these in your ResourceManager!")

func _generate_character_assets() -> void:
    print("\n--- Generating Character Assets ---")
    
    # Simple stickman character
    var stickman_texture := _create_simple_stickman()
    _save_texture(stickman_texture, "stickman.png")
    
    # Animation frames
    for frame in range(4):
        var frame_texture := _create_walk_frame(frame)
        _save_texture(frame_texture, "stickman_walk_" + str(frame) + ".png")
    
    print("✓ Character assets generated")

func _create_simple_stickman() -> ImageTexture:
    var image := Image.create(64, 64, false, Image.FORMAT_RGBA8)
    image.fill(Color.TRANSPARENT)
    
    # Shadow
    _draw_ellipse(image, Vector2i(32, 52), Vector2i(20, 8), Color(0, 0, 0, 0.3))
    
    # Body
    _draw_rect_rounded(image, Rect2i(28, 20, 8, 20), Color(0.95, 0.85, 0.75), 2, Color(0.2, 0.15, 0.1))
    
    # Head
    _draw_circle_filled(image, Vector2i(32, 16), 8, Color(0.95, 0.85, 0.75), Color(0.2, 0.15, 0.1))
    
    # Eyes
    _draw_circle_filled(image, Vector2i(29, 14), 2, Color.WHITE, Color.BLACK)
    _draw_circle_filled(image, Vector2i(35, 14), 2, Color.WHITE, Color.BLACK)
    _draw_pixel(image, Vector2i(29, 14), Color.BLACK)
    _draw_pixel(image, Vector2i(35, 14), Color.BLACK)
    
    # Arms
    _draw_line_thick(image, Vector2i(20, 24), Vector2i(44, 24), 3, Color(0.95, 0.85, 0.75))
    _draw_line_thick(image, Vector2i(20, 24), Vector2i(44, 24), 1, Color(0.2, 0.15, 0.1))
    
    # Legs
    _draw_line_thick(image, Vector2i(30, 38), Vector2i(28, 56), 3, Color(0.95, 0.85, 0.75))
    _draw_line_thick(image, Vector2i(34, 38), Vector2i(36, 56), 3, Color(0.95, 0.85, 0.75))
    _draw_line_thick(image, Vector2i(30, 38), Vector2i(28, 56), 1, Color(0.2, 0.15, 0.1))
    _draw_line_thick(image, Vector2i(34, 38), Vector2i(36, 56), 1, Color(0.2, 0.15, 0.1))
    
    return ImageTexture.create_from_image(image)

func _create_walk_frame(frame: int) -> ImageTexture:
    var image := Image.create(64, 64, false, Image.FORMAT_RGBA8)
    image.fill(Color.TRANSPARENT)
    
    # Walking animation
    var offset_y := int(sin(frame * PI / 2.0) * 3)
    var stretch_x := 1.0 + abs(cos(frame * PI / 2.0)) * 0.1
    
    # Shadow
    _draw_ellipse(image, Vector2i(32, 52), Vector2i(20, 8), Color(0, 0, 0, 0.3))
    
    # Body with animation
    var body_rect := Rect2i(28 - int(4 * stretch_x), 20 + offset_y, int(8 * stretch_x), 20)
    _draw_rect_rounded(image, body_rect, Color(0.95, 0.85, 0.75), 2, Color(0.2, 0.15, 0.1))
    
    # Head
    _draw_circle_filled(image, Vector2i(32, 16 + offset_y), 8, Color(0.95, 0.85, 0.75), Color(0.2, 0.15, 0.1))
    
    # Eyes
    _draw_circle_filled(image, Vector2i(29, 14 + offset_y), 2, Color.WHITE, Color.BLACK)
    _draw_circle_filled(image, Vector2i(35, 14 + offset_y), 2, Color.WHITE, Color.BLACK)
    _draw_pixel(image, Vector2i(29, 14 + offset_y), Color.BLACK)
    _draw_pixel(image, Vector2i(35, 14 + offset_y), Color.BLACK)
    
    # Arms with animation
    var arm_wave := int(sin(frame * 0.5) * 2)
    _draw_line_thick(image, Vector2i(20, 24 + arm_wave), Vector2i(44, 24 - arm_wave), 3, Color(0.95, 0.85, 0.75))
    
    # Legs with walking animation
    var leg_offset := int(sin(frame * 1.0) * 2)
    _draw_line_thick(image, Vector2i(30, 38), Vector2i(28 - leg_offset, 56), 3, Color(0.95, 0.85, 0.75))
    _draw_line_thick(image, Vector2i(34, 38), Vector2i(36 + leg_offset, 56), 3, Color(0.95, 0.85, 0.75))
    _draw_line_thick(image, Vector2i(30, 38), Vector2i(28 - leg_offset, 56), 1, Color(0.2, 0.15, 0.1))
    _draw_line_thick(image, Vector2i(34, 38), Vector2i(36 + leg_offset, 56), 1, Color(0.2, 0.15, 0.1))
    
    return ImageTexture.create_from_image(image)

func _generate_gate_assets() -> void:
    print("\n--- Generating Gate Assets ---")
    
    var operations := ["add", "subtract", "multiply", "divide"]
    var colors := {
        "add": Color(0.2, 0.8, 0.3),
        "subtract": Color(0.9, 0.3, 0.2),
        "multiply": Color(0.2, 0.5, 0.9),
        "divide": Color(0.9, 0.6, 0.2)
    }
    
    for operation in operations:
        var gate_texture := _create_simple_gate(operation, colors[operation])
        _save_texture(gate_texture, "gate_" + operation + ".png")
    
    print("✓ Gate assets generated")

func _create_simple_gate(operation: String, color: Color) -> ImageTexture:
    var image := Image.create(96, 144, false, Image.FORMAT_RGBA8)
    image.fill(Color.TRANSPARENT)
    
    # Gate frame
    _draw_rect_rounded(image, Rect2i(4, 4, 88, 136), color, 3, Color.WHITE)
    
    # Symbol background
    _draw_rect_rounded(image, Rect2i(16, 52, 64, 40), Color.WHITE, 2, color)
    
    # Draw symbol
    var symbol := ""
    match operation:
        "add":
            symbol = "+"
        "subtract":
            symbol = "−"
        "multiply":
            symbol = "×"
        "divide":
            symbol = "÷"
        _:
            symbol = "?"
    
    _draw_math_symbol(image, symbol, Vector2i(48, 72), Color.BLACK)
    
    return ImageTexture.create_from_image(image)

func _generate_obstacle_assets() -> void:
    print("\n--- Generating Obstacle Assets ---")
    
    var obstacle_types := ["barrier", "spike", "enemy", "zone"]
    
    for obstacle_type in obstacle_types:
        var obstacle_texture := _create_simple_obstacle(obstacle_type)
        _save_texture(obstacle_texture, "obstacle_" + obstacle_type + ".png")
    
    print("✓ Obstacle assets generated")

func _create_simple_obstacle(obstacle_type: String) -> ImageTexture:
    var image := Image.create(48, 48, false, Image.FORMAT_RGBA8)
    image.fill(Color.TRANSPARENT)
    
    match obstacle_type:
        "barrier":
            _draw_barrier_obstacle(image)
        "spike":
            _draw_spike_obstacle(image)
        "enemy":
            _draw_enemy_obstacle(image)
        "zone":
            _draw_zone_obstacle(image)
        _:
            _draw_default_obstacle(image)
    
    return ImageTexture.create_from_image(image)

func _draw_barrier_obstacle(image: Image) -> void:
    _draw_rect_rounded(image, Rect2i(8, 4, 32, 40), Color(0.4, 0.4, 0.45), 2, Color.BLACK)
    
    # Warning stripes
    for i in range(0, 40, 8):
        for y in range(i, min(i + 4, 40)):
            for x in range(10, 38):
                _draw_pixel(image, Vector2i(x, y), Color(0.3, 0.3, 0.35))

func _draw_spike_obstacle(image: Image) -> void:
    # Triangle spike
    var points := [
        Vector2i(24, 8),   # Top tip
        Vector2i(8, 40),   # Bottom left
        Vector2i(40, 40)   # Bottom right
    ]
    
    # Fill triangle
    for x in range(8, 41):
        for y in range(8, 41):
            if _point_in_triangle(Vector2i(x, y), points):
                var dist := Vector2(x, y).distance_to(Vector2(24, 8))
                var t := dist / 32.0
                var pixel_color := Color(0.2, 0.2, 0.25).lerp(Color(0.1, 0.1, 0.15), t)
                _draw_pixel(image, Vector2i(x, y), pixel_color)

func _draw_enemy_obstacle(image: Image) -> void:
    _draw_rect_rounded(image, Rect2i(12, 8, 24, 24), Color(0.8, 0.2, 0.2), 2, Color.BLACK)
    
    # Angry eyes
    _draw_rect_rounded(image, Rect2i(16, 14, 4, 4), Color.WHITE, 1, Color.BLACK)
    _draw_rect_rounded(image, Rect2i(28, 14, 4, 4), Color.WHITE, 1, Color.BLACK)
    _draw_rect_rounded(image, Rect2i(17, 15, 2, 2), Color.BLACK, 0, Color.BLACK)
    _draw_rect_rounded(image, Rect2i(29, 15, 2, 2), Color.BLACK, 0, Color.BLACK)
    
    # Angry mouth
    for x in range(18, 30):
        _draw_pixel(image, Vector2i(x, 24), Color.BLACK)

func _draw_zone_obstacle(image: Image) -> void:
    var color := Color(0.7, 0.3, 0.1)
    
    # Danger zone with gradient
    for x in range(image.get_width()):
        for y in range(image.get_height()):
            var center_dist := Vector2(x, y).distance_to(Vector2(24, 24))
            var alpha := max(0.0, 1.0 - center_dist / 20.0)
            var pixel_color := Color(color.r, color.g, color.b, alpha * 0.7)
            _draw_pixel(image, Vector2i(x, y), pixel_color)

func _draw_default_obstacle(image: Image) -> void:
    _draw_rect_rounded(image, Rect2i(8, 8, 32, 32), Color.GRAY, 2, Color.BLACK)

func _generate_ui_assets() -> void:
    print("\n--- Generating UI Assets ---")
    
    # Button states
    var button_states := ["normal", "hover", "pressed"]
    for state in button_states:
        var button_texture := _create_simple_button(state)
        _save_texture(button_texture, "ui_button_" + state + ".png")
    
    # Create simple icons
    var icons := ["heart", "star", "gear", "arrow_left", "arrow_right"]
    for icon_name in icons:
        var icon_texture := _create_simple_icon(icon_name)
        _save_texture(icon_texture, "ui_icon_" + icon_name + ".png")
    
    print("✓ UI assets generated")

func _create_simple_button(state: String) -> ImageTexture:
    var image := Image.create(120, 40, false, Image.FORMAT_RGBA8)
    image.fill(Color.TRANSPARENT)
    
    var color := Color.BLUE
    match state:
        "normal":
            color = Color(0.2, 0.4, 0.8)
        "hover":
            color = Color(0.3, 0.6, 0.9)
        "pressed":
            color = Color(0.1, 0.3, 0.7)
        "disabled":
            color = Color(0.3, 0.3, 0.3)
    
    _draw_rect_rounded(image, Rect2i(4, 4, 112, 32), color, 2, Color.WHITE)
    return ImageTexture.create_from_image(image)

func _create_simple_icon(icon_name: String) -> ImageTexture:
    var image := Image.create(32, 32, false, Image.FORMAT_RGBA8)
    image.fill(Color.TRANSPARENT)
    
    match icon_name:
        "heart":
            _draw_heart_icon(image)
        "star":
            _draw_star_icon(image)
        "gear":
            _draw_gear_icon(image)
        "arrow_left":
            _draw_arrow_icon(image, false)
        "arrow_right":
            _draw_arrow_icon(image, true)
        _:
            _draw_default_icon(image)
    
    return ImageTexture.create_from_image(image)

func _draw_heart_icon(image: Image) -> void:
    _draw_circle_filled(image, Vector2i(10, 10), 6, Color.RED, Color.RED)
    _draw_circle_filled(image, Vector2i(22, 10), 6, Color.RED, Color.RED)
    _draw_rect_rounded(image, Rect2i(6, 12, 20, 12), Color.RED, 0, Color.RED)

func _draw_star_icon(image: Image) -> void:
    var center := Vector2i(16, 16)
    var points := []
    for i in range(10):
        var angle := (PI * 2.0 * i) / 10.0
        var radius := 12.0 if i % 2 == 0 else 6.0
        var point := center + Vector2i(int(cos(angle) * radius), int(sin(angle) * radius))
        points.append(point)
    
    # Draw star polygon (simplified as connected lines)
    for i in range(points.size()):
        var next := (i + 1) % points.size()
        _draw_line_thick(image, points[i], points[next], 2, Color.YELLOW)

func _draw_gear_icon(image: Image) -> void:
    _draw_circle_filled(image, Vector2i(16, 16), 10, Color.GRAY, Color.DARK_GRAY)
    _draw_circle_filled(image, Vector2i(16, 16), 4, Color.TRANSPARENT, Color.DARK_GRAY)
    
    # Gear teeth
    for i in range(8):
        var angle := (PI * 2.0 * i) / 8.0
        var x := int(16 + cos(angle) * 12)
        var y := int(16 + sin(angle) * 12)
        _draw_rect_rounded(image, Rect2i(x - 2, y - 2, 4, 4), Color.GRAY, 1, Color.DARK_GRAY)

func _draw_arrow_icon(image: Image, right: bool) -> void:
    if right:
        _draw_line_thick(image, Vector2i(8, 16), Vector2i(20, 16), 3, Color.WHITE)
        _draw_line_thick(image, Vector2i(20, 16), Vector2i(16, 12), 2, Color.WHITE)
        _draw_line_thick(image, Vector2i(20, 16), Vector2i(16, 20), 2, Color.WHITE)
    else:
        _draw_line_thick(image, Vector2i(24, 16), Vector2i(12, 16), 3, Color.WHITE)
        _draw_line_thick(image, Vector2i(12, 16), Vector2i(16, 12), 2, Color.WHITE)
        _draw_line_thick(image, Vector2i(12, 16), Vector2i(16, 20), 2, Color.WHITE)

func _draw_default_icon(image: Image) -> void:
    _draw_circle_filled(image, Vector2i(16, 16), 8, Color.GRAY, Color.DARK_GRAY)

func _generate_environment_assets() -> void:
    print("\n--- Generating Environment Assets ---")
    
    # Ground texture
    var ground_texture := _create_ground_texture()
    _save_texture(ground_texture, "ground.png")
    
    # Background texture
    var background_texture := _create_background_texture()
    _save_texture(background_texture, "background.png")
    
    # Finish line
    var finish_texture := _create_finish_line()
    _save_texture(finish_texture, "finish_line.png")
    
    print("✓ Environment assets generated")

func _create_ground_texture() -> ImageTexture:
    var image := Image.create(128, 32, false, Image.FORMAT_RGBA8)
    
    # Base ground color
    var base_color := Color(0.4, 0.3, 0.2)
    var tile_color := Color(0.45, 0.35, 0.25)
    
    for x in range(128):
        for y in range(32):
            if (x % 16 < 8) and (y % 8 < 4):
                _draw_pixel(image, Vector2i(x, y), tile_color)
            else:
                _draw_pixel(image, Vector2i(x, y), base_color)
    
    return ImageTexture.create_from_image(image)

func _create_background_texture() -> ImageTexture:
    var image := Image.create(512, 256, false, Image.FORMAT_RGBA8)
    
    # Sky gradient
    for y in range(256):
        var t := float(y) / 256.0
        var color := Color(0.7 - t * 0.3, 0.8 - t * 0.3, 0.9 - t * 0.2)
        for x in range(512):
            _draw_pixel(image, Vector2i(x, y), color)
    
    # Add simple clouds
    for i in range(5):
        var x := 50 + i * 80
        var y := 30 + i * 20
        _draw_circle_filled(image, Vector2i(x, y), 20, Color(1.0, 1.0, 1.0, 0.8))
    
    return ImageTexture.create_from_image(image)

func _create_finish_line() -> ImageTexture:
    var image := Image.create(100, 200, false, Image.FORMAT_RGBA8)
    image.fill(Color.TRANSPARENT)
    
    # Checkered pattern for finish line
    for x in range(100):
        for y in range(200):
            var is_white := ((x / 20) % 2) == ((y / 20) % 2)
            var color := Color.WHITE if is_white else Color.BLACK
            _draw_pixel(image, Vector2i(x, y), color)
    
    return ImageTexture.create_from_image(image)

# Helper functions
func _draw_math_symbol(image: Image, symbol: String, pos: Vector2i, color: Color) -> void:
    # Simple symbol drawing
    match symbol:
        "+":
            # Horizontal line
            for x in range(pos.x - 8, pos.x + 9):
                _draw_pixel(image, Vector2i(x, pos.y), color)
            # Vertical line
            for y in range(pos.y - 8, pos.y + 9):
                _draw_pixel(image, Vector2i(pos.x, pos.y), color)
        "−":
            # Horizontal line (minus)
            for x in range(pos.x - 8, pos.x + 9):
                _draw_pixel(image, Vector2i(x, pos.y), color)
        "×":
            # Diagonal lines for multiplication
            for i in range(-8, 9):
                _draw_pixel(image, Vector2i(pos.x + i, pos.y + i), color)
                _draw_pixel(image, Vector2i(pos.x + i, pos.y - i), color)
        "÷":
            # Horizontal line
            for x in range(pos.x - 8, pos.x + 9):
                _draw_pixel(image, Vector2i(x, pos.y), color)
            # Dots above and below
            _draw_pixel(image, Vector2i(pos.x, pos.y - 6), color)
            _draw_pixel(image, Vector2i(pos.x, pos.y + 6), color)

func _save_texture(texture: ImageTexture, filename: String) -> void:
    var image := texture.get_image()
    image.save_png("res://assets/textures/" + filename)
    print("  Saved: " + filename)

func _draw_pixel(image: Image, pos: Vector2i, color: Color) -> void:
    if pos.x >= 0 and pos.x < image.get_width() and pos.y >= 0 and pos.y < image.get_height():
        image.set_pixel(pos.x, pos.y, color)

func _draw_line_thick(image: Image, start: Vector2i, end: Vector2i, thickness: int, color: Color) -> void:
    var dx := abs(end.x - start.x)
    var dy := abs(end.y - start.y)
    var sx := 1 if start.x < end.x else -1
    var sy := 1 if start.y < end.y else -1
    var err := dx - dy
    
    var x := start.x
    var y := start.y
    
    while true:
        for i in range(-thickness/2, thickness/2 + 1):
            for j in range(-thickness/2, thickness/2 + 1):
                _draw_pixel(image, Vector2i(x + i, y + j), color)
        
        if x == end.x and y == end.y:
            break
        
        var e2 := 2 * err
        if e2 > -dy:
            err -= dy
            x += sx
        if e2 < dx:
            err += dx
            y += sy

func _draw_rect_rounded(image: Image, rect: Rect2i, color: Color, border: int, border_color: Color) -> void:
    # Fill
    for x in range(rect.position.x + border, rect.position.x + rect.size.x - border):
        for y in range(rect.position.y + border, rect.position.y + rect.size.y - border):
            _draw_pixel(image, Vector2i(x, y), color)
    
    # Border
    for i in range(border):
        for x in range(rect.position.x, rect.position.x + rect.size.x):
            _draw_pixel(image, Vector2i(x, rect.position.y + i), border_color)
            _draw_pixel(image, Vector2i(x, rect.position.y + rect.size.y - 1 - i), border_color)
        
        for y in range(rect.position.y, rect.position.y + rect.size.y):
            _draw_pixel(image, Vector2i(rect.position.x + i, y), border_color)
            _draw_pixel(image, Vector2i(rect.position.x + rect.size.x - 1 - i, y), border_color)

func _draw_circle_filled(image: Image, center: Vector2i, radius: int, fill_color: Color, outline_color: Color) -> void:
    for x in range(center.x - radius - 1, center.x + radius + 2):
        for y in range(center.y - radius - 1, center.y + radius + 2):
            var dist := Vector2(x, y).distance_to(Vector2(center.x, center.y))
            if dist <= radius:
                _draw_pixel(image, Vector2i(x, y), fill_color)
            elif dist <= radius + 1:
                _draw_pixel(image, Vector2i(x, y), outline_color)

func _draw_ellipse(image: Image, center: Vector2i, size: Vector2i, color: Color) -> void:
    for x in range(center.x - size.x/2, center.x + size.x/2):
        for y in range(center.y - size.y/2, center.y + size.y/2):
            var dx := float(x - center.x) / (size.x/2.0)
            var dy := float(y - center.y) / (size.y/2.0)
            if dx*dx + dy*dy <= 1.0:
                _draw_pixel(image, Vector2i(x, y), color)

func _point_in_triangle(point: Vector2i, points: Array[Vector2i]) -> bool:
    # Simple barycentric coordinate method
    var v0 := points[1] - points[0]
    var v1 := points[2] - points[0]
    var v2 := point - points[0]
    
    var dot00 := v0.x * v0.x + v0.y * v0.y
    var dot01 := v0.x * v1.x + v0.y * v1.y
    var dot02 := v0.x * v2.x + v0.y * v2.y
    var dot11 := v1.x * v1.x + v1.y * v1.y
    var dot12 := v1.x * v2.x + v1.y * v2.y
    
    var inv_denom := 1.0 / (dot00 * dot11 - dot01 * dot01)
    var u := (dot11 * dot02 - dot01 * dot12) * inv_denom
    var v := (dot00 * dot12 - dot01 * dot02) * inv_denom
    
    return (u >= 0) and (v >= 0) and (u + v <= 1)