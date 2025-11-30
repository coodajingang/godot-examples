extends Resource
class_name AdvancedTextureGenerator

# Advanced texture generator for Math Runner game
# Creates high-quality 2D game assets with detailed pixel art

# Color palettes for game elements
const STICKMAN_COLORS := {
    "skin": Color(0.95, 0.85, 0.75),
    "outline": Color(0.2, 0.15, 0.1),
    "clothing": Color(0.2, 0.4, 0.8),
    "shadow": Color(0.0, 0.0, 0.0, 0.3)
}

const GATE_COLORS := {
    "add": Color(0.2, 0.8, 0.3),      # Green
    "subtract": Color(0.9, 0.3, 0.2),   # Red
    "multiply": Color(0.2, 0.5, 0.9),   # Blue
    "divide": Color(0.9, 0.6, 0.2)     # Orange
}

const OBSTACLE_COLORS := {
    "barrier": Color(0.4, 0.4, 0.45),    # Gray
    "spike": Color(0.2, 0.2, 0.25),     # Dark gray
    "enemy": Color(0.8, 0.2, 0.2),       # Red
    "zone": Color(0.7, 0.3, 0.1)        # Brown
}

# Creates a detailed stickman character with animation frames
static func create_detailed_stickman_texture() -> ImageTexture:
    var image := Image.create(64, 64, false, Image.FORMAT_RGBA8)
    image.fill(Color.TRANSPARENT)
    
    # Draw shadow
    _draw_ellipse(image, Vector2i(32, 52), Vector2i(20, 8), STICKMAN_COLORS.shadow)
    
    # Draw body
    _draw_rect_rounded(image, Rect2i(28, 20, 8, 20), STICKMAN_COLORS.skin, 2, STICKMAN_COLORS.outline)
    
    # Draw head
    _draw_circle_filled(image, Vector2i(32, 16), 8, STICKMAN_COLORS.skin, STICKMAN_COLORS.outline)
    
    # Draw eyes
    _draw_circle_filled(image, Vector2i(29, 14), 2, Color.WHITE, Color.BLACK)
    _draw_circle_filled(image, Vector2i(35, 14), 2, Color.WHITE, Color.BLACK)
    _draw_pixel(image, Vector2i(29, 14), Color.BLACK)
    _draw_pixel(image, Vector2i(35, 14), Color.BLACK)
    
    # Draw arms
    _draw_line_thick(image, Vector2i(20, 24), Vector2i(44, 24), 3, STICKMAN_COLORS.skin)
    _draw_line_thick(image, Vector2i(20, 24), Vector2i(44, 24), 1, STICKMAN_COLORS.outline)
    
    # Draw legs
    _draw_line_thick(image, Vector2i(30, 38), Vector2i(28, 56), 3, STICKMAN_COLORS.skin)
    _draw_line_thick(image, Vector2i(34, 38), Vector2i(36, 56), 3, STICKMAN_COLORS.skin)
    _draw_line_thick(image, Vector2i(30, 38), Vector2i(28, 56), 1, STICKMAN_COLORS.outline)
    _draw_line_thick(image, Vector2i(34, 38), Vector2i(36, 56), 1, STICKMAN_COLORS.outline)
    
    return ImageTexture.create_from_image(image)

# Creates detailed math gate with symbols
static func create_detailed_gate_texture(operation: String) -> ImageTexture:
    var image := Image.create(96, 144, false, Image.FORMAT_RGBA8)
    image.fill(Color.TRANSPARENT)
    
    var base_color := GATE_COLORS[operation]
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
    
    # Draw gate frame with gradient
    _draw_gate_frame(image, base_color)
    
    # Draw symbol background
    _draw_rect_rounded(image, Rect2i(16, 52, 64, 40), Color.WHITE, 3, base_color)
    
    # Draw symbol (simplified pixel font)
    _draw_math_symbol(image, symbol, Vector2i(48, 72), Color.BLACK)
    
    # Add glow effect
    _add_glow_effect(image, base_color)
    
    return ImageTexture.create_from_image(image)

# Creates detailed obstacle textures
static func create_detailed_obstacle_texture(type: String) -> ImageTexture:
    var image := Image.create(48, 48, false, Image.FORMAT_RGBA8)
    image.fill(Color.TRANSPARENT)
    
    match type:
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

# Creates UI elements
static func create_button_texture(state: String) -> ImageTexture:
    var image := Image.create(120, 40, false, Image.FORMAT_RGBA8)
    image.fill(Color.TRANSPARENT)
    
    var color := Color.BLUE
    var text_color := Color.WHITE
    
    match state:
        "normal":
            color = Color(0.2, 0.4, 0.8)
        "hover":
            color = Color(0.3, 0.6, 0.9)
        "pressed":
            color = Color(0.1, 0.3, 0.7)
    
    _draw_rect_rounded(image, Rect2i(2, 2, 116, 36), color, 2, Color.WHITE)
    
    return ImageTexture.create_from_image(image)

# Creates ground texture with tiles
static func create_ground_texture() -> ImageTexture:
    var image := Image.create(128, 32, false, Image.FORMAT_RGBA8)
    
    # Base ground color
    var base_color := Color(0.4, 0.3, 0.2)
    var tile_color := Color(0.45, 0.35, 0.25)
    
    for x in range(128):
        for y in range(32):
            if (x % 16 < 8) and (y % 8 < 4):
                image.set_pixel(x, y, tile_color)
            else:
                image.set_pixel(x, y, base_color)
    
    # Add some texture variation
    for i in range(20):
        var x := randi() % 128
        var y := randi() % 32
        var variation := Color(base_color.r + randf_range(-0.05, 0.05), 
                               base_color.g + randf_range(-0.05, 0.05),
                               base_color.b + randf_range(-0.05, 0.05))
        image.set_pixel(x, y, variation)
    
    return ImageTexture.create_from_image(image)

# Creates background texture
static func create_background_texture() -> ImageTexture:
    var image := Image.create(512, 256, false, Image.FORMAT_RGBA8)
    
    # Sky gradient
    for y in range(256):
        var t := float(y) / 256.0
        var color := Color(0.7 - t * 0.3, 0.8 - t * 0.3, 0.9 - t * 0.2)
        for x in range(512):
            image.set_pixel(x, y, color)
    
    # Add clouds
    _draw_clouds(image)
    
    # Add distant mountains
    _draw_mountains(image)
    
    return ImageTexture.create_from_image(image)

# Helper functions for drawing
static func _draw_pixel(image: Image, pos: Vector2i, color: Color) -> void:
    if pos.x >= 0 and pos.x < image.get_width() and pos.y >= 0 and pos.y < image.get_height():
        image.set_pixel(pos.x, pos.y, color)

static func _draw_line_thick(image: Image, start: Vector2i, end: Vector2i, thickness: int, color: Color) -> void:
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

static func _draw_circle_filled(image: Image, center: Vector2i, radius: int, fill_color: Color, outline_color: Color) -> void:
    for x in range(center.x - radius - 1, center.x + radius + 2):
        for y in range(center.y - radius - 1, center.y + radius + 2):
            var dist := Vector2(x, y).distance_to(Vector2(center.x, center.y))
            if dist <= radius:
                image.set_pixel(x, y, fill_color)
            elif dist <= radius + 1:
                image.set_pixel(x, y, outline_color)

static func _draw_rect_rounded(image: Image, rect: Rect2i, color: Color, border: int, border_color: Color) -> void:
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

static func _draw_ellipse(image: Image, center: Vector2i, size: Vector2i, color: Color) -> void:
    for x in range(center.x - size.x/2, center.x + size.x/2):
        for y in range(center.y - size.y/2, center.y + size.y/2):
            var dx := float(x - center.x) / (size.x/2.0)
            var dy := float(y - center.y) / (size.y/2.0)
            if dx*dx + dy*dy <= 1.0:
                _draw_pixel(image, Vector2i(x, y), color)

static func _draw_gate_frame(image: Image, color: Color) -> void:
    # Outer frame
    _draw_rect_rounded(image, Rect2i(4, 4, 88, 136), color, 3, Color.WHITE)
    
    # Inner highlight
    var highlight := Color(color.r + 0.2, color.g + 0.2, color.b + 0.2)
    _draw_rect_rounded(image, Rect2i(8, 8, 80, 128), highlight, 2, color)

static func _draw_math_symbol(image: Image, symbol: String, pos: Vector2i, color: Color) -> void:
    # Simple pixel font drawing for math symbols
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

static func _add_glow_effect(image: Image, base_color: Color) -> void:
    var glow_color := Color(base_color.r, base_color.g, base_color.b, 0.3)
    
    # Add subtle glow around edges
    for x in range(image.get_width()):
        for y in range(image.get_height()):
            if image.get_pixel(x, y).a > 0:  # If pixel is not transparent
                for dx in range(-2, 3):
                    for dy in range(-2, 3):
                        var nx := x + dx
                        var ny := y + dy
                        if nx >= 0 and nx < image.get_width() and ny >= 0 and ny < image.get_height():
                            if image.get_pixel(nx, ny).a == 0:  # If neighbor is transparent
                                _draw_pixel(image, Vector2i(nx, ny), glow_color)

static func _draw_barrier_obstacle(image: Image) -> void:
    var color := OBSTACLE_COLORS.barrier
    var stripe_color := Color(0.3, 0.3, 0.35)
    
    # Main body
    _draw_rect_rounded(image, Rect2i(8, 4, 32, 40), color, 2, Color.BLACK)
    
    # Warning stripes
    for i in range(0, 40, 8):
        for y in range(i, min(i + 4, 40)):
            for x in range(10, 38):
                image.set_pixel(x, y, stripe_color)

static func _draw_spike_obstacle(image: Image) -> void:
    var color := OBSTACLE_COLORS.spike
    var tip_color := Color(0.1, 0.1, 0.15)
    
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
                var pixel_color := color.lerp(tip_color, t)
                _draw_pixel(image, Vector2i(x, y), pixel_color)

static func _draw_enemy_obstacle(image: Image) -> void:
    var color := OBSTACLE_COLORS.enemy
    
    # Body
    _draw_rect_rounded(image, Rect2i(12, 8, 24, 24), color, 2, Color.BLACK)
    
    # Angry eyes
    _draw_rect_rounded(image, Rect2i(16, 14, 4, 4), Color.WHITE, 1, Color.BLACK)
    _draw_rect_rounded(image, Rect2i(28, 14, 4, 4), Color.WHITE, 1, Color.BLACK)
    _draw_rect_rounded(image, Rect2i(17, 15, 2, 2), Color.BLACK, 0, Color.BLACK)
    _draw_rect_rounded(image, Rect2i(29, 15, 2, 2), Color.BLACK, 0, Color.BLACK)
    
    # Angry mouth
    for x in range(18, 30):
        image.set_pixel(x, 24, Color.BLACK)

static func _draw_zone_obstacle(image: Image) -> void:
    var color := OBSTACLE_COLORS.zone
    
    # Danger zone with gradient
    for x in range(image.get_width()):
        for y in range(image.get_height()):
            var center_dist := Vector2(x, y).distance_to(Vector2(24, 24))
            var alpha := max(0.0, 1.0 - center_dist / 20.0)
            var pixel_color := Color(color.r, color.g, color.b, alpha * 0.7)
            _draw_pixel(image, Vector2i(x, y), pixel_color)

static func _draw_default_obstacle(image: Image) -> void:
    _draw_rect_rounded(image, Rect2i(8, 8, 32, 32), Color.GRAY, 2, Color.BLACK)

static func _point_in_triangle(point: Vector2i, points: Array[Vector2i]) -> bool:
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

static func _draw_clouds(image: Image) -> void:
    # Draw simple cloud shapes
    var cloud_color := Color(1.0, 1.0, 1.0, 0.8)
    
    # Cloud 1
    _draw_circle_filled(image, Vector2i(100, 60), 15, cloud_color, cloud_color)
    _draw_circle_filled(image, Vector2i(120, 55), 18, cloud_color, cloud_color)
    _draw_circle_filled(image, Vector2i(140, 58), 12, cloud_color, cloud_color)
    
    # Cloud 2
    _draw_circle_filled(image, Vector2i(300, 80), 20, cloud_color, cloud_color)
    _draw_circle_filled(image, Vector2i(325, 75), 25, cloud_color, cloud_color)
    _draw_circle_filled(image, Vector2i(350, 82), 15, cloud_color, cloud_color)

static func _draw_mountains(image: Image) -> void:
    # Simple mountain silhouettes
    var mountain_color := Color(0.3, 0.2, 0.1)
    
    # Mountain range
    for x in range(512):
        var height := int(80 + 40 * sin(x * 0.02) + 20 * sin(x * 0.05))
        for y in range(256 - height, 256):
            _draw_pixel(image, Vector2i(x, y), mountain_color)