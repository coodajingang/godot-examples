extends Resource
class_name SpriteSheetGenerator

# Sprite sheet generator for creating animated characters and effects
# Creates properly formatted sprite sheets with multiple animation frames

# Sprite sheet configurations
const SPRITE_SHEET_SIZE := Vector2i(512, 512)
const FRAME_SIZE := Vector2i(64, 64)
const FRAMES_PER_ROW := 8
const FRAMES_PER_COL := 8

# Creates a complete character sprite sheet with all animations
static func create_character_sprite_sheet() -> ImageTexture:
    var sheet := Image.create(SPRITE_SHEET_SIZE.x, SPRITE_SHEET_SIZE.y, false, Image.FORMAT_RGBA8)
    sheet.fill(Color.TRANSPARENT)
    
    # Define animation frame positions
    var frames := {
        # Row 0: Idle animation
        "idle_0": Vector2i(0, 0),
        "idle_1": Vector2i(1, 0),
        "idle_2": Vector2i(2, 0),
        "idle_3": Vector2i(3, 0),
        
        # Row 1: Walk animation
        "walk_0": Vector2i(0, 1),
        "walk_1": Vector2i(1, 1),
        "walk_2": Vector2i(2, 1),
        "walk_3": Vector2i(3, 1),
        "walk_4": Vector2i(4, 1),
        "walk_5": Vector2i(5, 1),
        "walk_6": Vector2i(6, 1),
        "walk_7": Vector2i(7, 1),
        
        # Row 2: Jump animation
        "jump_0": Vector2i(0, 2),
        "jump_1": Vector2i(1, 2),
        "jump_2": Vector2i(2, 2),
        "jump_3": Vector2i(3, 2),
        
        # Row 3: Death animation
        "death_0": Vector2i(0, 3),
        "death_1": Vector2i(1, 3),
        "death_2": Vector2i(2, 3),
        "death_3": Vector2i(3, 3),
        "death_4": Vector2i(4, 3),
        "death_5": Vector2i(5, 3),
    }
    
    # Draw each frame
    for frame_name in frames:
        var pos := frames[frame_name]
        var pixel_pos := Vector2i(pos.x * FRAME_SIZE.x, pos.y * FRAME_SIZE.y)
        _draw_character_frame(sheet, pixel_pos, frame_name)
    
    return ImageTexture.create_from_image(sheet)

# Draws individual character frame based on animation type
static func _draw_character_frame(sheet: Image, pos: Vector2i, frame_name: String) -> void:
    var base_pos := pos + Vector2i(FRAME_SIZE.x / 2, FRAME_SIZE.y / 2)
    
    # Extract animation type and frame number
    var parts := frame_name.split("_")
    var anim_type := parts[0]
    var frame_num := int(parts[1]) if parts.size() > 1 else 0
    
    match anim_type:
        "idle":
            _draw_idle_frame(sheet, base_pos, frame_num)
        "walk":
            _draw_walk_frame(sheet, base_pos, frame_num)
        "jump":
            _draw_jump_frame(sheet, base_pos, frame_num)
        "death":
            _draw_death_frame(sheet, base_pos, frame_num)

# Idle animation frames
static func _draw_idle_frame(sheet: Image, pos: Vector2i, frame: int) -> void:
    var colors := _get_character_colors()
    
    # Subtle breathing animation
    var breathe_scale := 1.0 + sin(frame * PI / 2.0) * 0.05
    var body_height := int(20 * breathe_scale)
    
    # Shadow
    _draw_ellipse(sheet, pos + Vector2i(0, 20), Vector2i(16, 6), Color(0, 0, 0, 0.3))
    
    # Body
    _draw_rect_rounded(sheet, Rect2i(pos.x - 4, pos.y - 10, 8, body_height), colors.skin, 2, colors.outline)
    
    # Head
    var head_bob := int(sin(frame * PI / 2.0) * 2)
    _draw_circle_filled(sheet, pos + Vector2i(0, -8 + head_bob), 8, colors.skin, colors.outline)
    
    # Eyes
    _draw_circle_filled(sheet, pos + Vector2i(-3, -10 + head_bob), 2, Color.WHITE, Color.BLACK)
    _draw_circle_filled(sheet, pos + Vector2i(3, -10 + head_bob), 2, Color.WHITE, Color.BLACK)
    _draw_pixel(sheet, pos + Vector2i(-3, -10 + head_bob), Color.BLACK)
    _draw_pixel(sheet, pos + Vector2i(3, -10 + head_bob), Color.BLACK)
    
    # Arms
    var arm_swing := int(sin(frame * PI / 2.0) * 1)
    _draw_line_thick(sheet, pos + Vector2i(-12, -4 + arm_swing), pos + Vector2i(12, -4 - arm_swing), 3, colors.skin)
    
    # Legs
    _draw_line_thick(sheet, pos + Vector2i(-2, 8), pos + Vector2i(-4, 20), 3, colors.skin)
    _draw_line_thick(sheet, pos + Vector2i(2, 8), pos + Vector2i(4, 20), 3, colors.skin)

# Walk animation frames
static func _draw_walk_frame(sheet: Image, pos: Vector2i, frame: int) -> void:
    var colors := _get_character_colors()
    
    # Walking cycle with leg movement
    var leg_offset := int(sin(frame * PI / 4.0) * 4)
    var arm_swing := int(sin(frame * PI / 4.0) * 2)
    var body_bob := int(abs(sin(frame * PI / 4.0)) * 1)
    
    # Shadow
    _draw_ellipse(sheet, pos + Vector2i(0, 20), Vector2i(16, 6), Color(0, 0, 0, 0.3))
    
    # Body (with slight bob)
    _draw_rect_rounded(sheet, Rect2i(pos.x - 4, pos.y - 10 + body_bob, 8, 20), colors.skin, 2, colors.outline)
    
    # Head
    _draw_circle_filled(sheet, pos + Vector2i(0, -8 + body_bob), 8, colors.skin, colors.outline)
    
    # Eyes
    _draw_circle_filled(sheet, pos + Vector2i(-3, -10 + body_bob), 2, Color.WHITE, Color.BLACK)
    _draw_circle_filled(sheet, pos + Vector2i(3, -10 + body_bob), 2, Color.WHITE, Color.BLACK)
    _draw_pixel(sheet, pos + Vector2i(-3, -10 + body_bob), Color.BLACK)
    _draw_pixel(sheet, pos + Vector2i(3, -10 + body_bob), Color.BLACK)
    
    # Arms (swinging)
    _draw_line_thick(sheet, pos + Vector2i(-12, -4 + arm_swing), pos + Vector2i(12, -4 - arm_swing), 3, colors.skin)
    
    # Legs (walking)
    _draw_line_thick(sheet, pos + Vector2i(-2, 8), pos + Vector2i(-4 - leg_offset, 20), 3, colors.skin)
    _draw_line_thick(sheet, pos + Vector2i(2, 8), pos + Vector2i(4 + leg_offset, 20), 3, colors.skin)

# Jump animation frames
static func _draw_jump_frame(sheet: Image, pos: Vector2i, frame: int) -> void:
    var colors := _get_character_colors()
    
    # Jump arc
    var jump_height := int(sin(frame * PI / 3.0) * -8)
    var stretch := 1.0 + abs(sin(frame * PI / 3.0)) * 0.2
    
    # Shadow (stretched)
    _draw_ellipse(sheet, pos + Vector2i(0, 20), Vector2i(24, 4), Color(0, 0, 0, 0.2))
    
    # Body (stretched)
    _draw_rect_rounded(sheet, Rect2i(pos.x - 4, pos.y - 10 + jump_height, int(8 * stretch), 20), colors.skin, 2, colors.outline)
    
    # Head
    _draw_circle_filled(sheet, pos + Vector2i(0, -8 + jump_height), 8, colors.skin, colors.outline)
    
    # Eyes
    _draw_circle_filled(sheet, pos + Vector2i(-3, -10 + jump_height), 2, Color.WHITE, Color.BLACK)
    _draw_circle_filled(sheet, pos + Vector2i(3, -10 + jump_height), 2, Color.WHITE, Color.BLACK)
    _draw_pixel(sheet, pos + Vector2i(-3, -10 + jump_height), Color.BLACK)
    _draw_pixel(sheet, pos + Vector2i(3, -10 + jump_height), Color.BLACK)
    
    # Arms (raised)
    _draw_line_thick(sheet, pos + Vector2i(-12, -8 + jump_height), pos + Vector2i(12, -8 + jump_height), 3, colors.skin)
    
    # Legs (jumping position)
    _draw_line_thick(sheet, pos + Vector2i(-6, 8), pos + Vector2i(-8, 18), 3, colors.skin)
    _draw_line_thick(sheet, pos + Vector2i(6, 8), pos + Vector2i(8, 18), 3, colors.skin)

# Death animation frames
static func _draw_death_frame(sheet: Image, pos: Vector2i, frame: int) -> void:
    var colors := _get_character_colors()
    
    match frame:
        0, 1, 2:
            # Initial death frames - character turns red and falls
            var fall_offset := frame * 4
            var alpha := 1.0 - frame * 0.2
            
            # Shadow
            _draw_ellipse(sheet, pos + Vector2i(0, 20), Vector2i(16, 6), Color(0, 0, 0, 0.3 * alpha))
            
            # Body (falling)
            _draw_rect_rounded(sheet, Rect2i(pos.x - 4, pos.y - 10 + fall_offset, 8, 20), Color(0.8, 0.2, 0.2, alpha), 2, Color(0.4, 0.1, 0.1, alpha))
            
            # Head
            _draw_circle_filled(sheet, pos + Vector2i(0, -8 + fall_offset), 8, Color(0.8, 0.2, 0.2, alpha), Color(0.4, 0.1, 0.1, alpha))
            
            # X eyes (dead)
            _draw_line_thick(sheet, pos + Vector2i(-3, -10 + fall_offset), pos + Vector2i(3, -6 + fall_offset), 1, Color.BLACK, alpha)
            _draw_line_thick(sheet, pos + Vector2i(3, -10 + fall_offset), pos + Vector2i(-3, -6 + fall_offset), 1, Color.BLACK, alpha)
        
        3, 4, 5:
            # Disintegration frames
            var particles := 8 - frame
            var fade := 1.0 - (frame - 2) * 0.3
            
            for i in range(particles * 3):
                var px := pos.x + randi_range(-20, 20)
                var py := pos.y + randi_range(-20, 20)
                var size := randi_range(1, 4)
                var particle_color := Color(0.8, 0.2, 0.2, fade * randf_range(0.5, 1.0))
                _draw_circle_filled(sheet, Vector2i(px, py), size, particle_color, particle_color)

# Helper functions for drawing shapes
static func _get_character_colors() -> Dictionary:
    return {
        "skin": Color(0.95, 0.85, 0.75),
        "outline": Color(0.2, 0.15, 0.1),
        "clothing": Color(0.2, 0.4, 0.8),
        "shadow": Color(0.0, 0.0, 0.0, 0.3)
    }

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
                _draw_pixel(image, Vector2i(x, y), fill_color)
            elif dist <= radius + 1:
                _draw_pixel(image, Vector2i(x, y), outline_color)

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

# Creates UI sprite sheet with buttons and icons
static func create_ui_sprite_sheet() -> ImageTexture:
    var sheet := Image.create(256, 256, false, Image.FORMAT_RGBA8)
    sheet.fill(Color.TRANSPARENT)
    
    # Button states
    var button_frames := ["normal", "hover", "pressed", "disabled"]
    for i in range(button_frames.size()):
        var pos := Vector2i(i * 64, 0)
        _draw_ui_button(sheet, pos, button_frames[i])
    
    # Icons
    var icons := ["heart", "star", "gear", "arrow_left", "arrow_right", "check", "x"]
    for i in range(icons.size()):
        var pos := Vector2i((i % 4) * 64, 64 + (i / 4) * 64)
        _draw_ui_icon(sheet, pos, icons[i])
    
    return ImageTexture.create_from_image(sheet)

# Draws UI button with different states
static func _draw_ui_button(sheet: Image, pos: Vector2i, state: String) -> void:
    var color := Color.BLUE
    var border_color := Color.WHITE
    
    match state:
        "normal":
            color = Color(0.2, 0.4, 0.8)
        "hover":
            color = Color(0.3, 0.6, 0.9)
        "pressed":
            color = Color(0.1, 0.3, 0.7)
        "disabled":
            color = Color(0.3, 0.3, 0.3)
    
    _draw_rect_rounded(sheet, Rect2i(pos.x + 4, pos.y + 8, 56, 32), color, 2, border_color)

# Draws UI icons
static func _draw_ui_icon(sheet: Image, pos: Vector2i, icon_type: String) -> void:
    var center := pos + Vector2i(32, 32)
    
    match icon_type:
        "heart":
            _draw_heart_icon(sheet, center)
        "star":
            _draw_star_icon(sheet, center)
        "gear":
            _draw_gear_icon(sheet, center)
        "arrow_left":
            _draw_arrow_icon(sheet, center, false)
        "arrow_right":
            _draw_arrow_icon(sheet, center, true)
        "check":
            _draw_check_icon(sheet, center)
        "x":
            _draw_x_icon(sheet, center)

# Individual icon drawing functions
static func _draw_heart_icon(sheet: Image, center: Vector2i) -> void:
    _draw_circle_filled(sheet, center + Vector2i(-8, -4), 8, Color.RED, Color.RED)
    _draw_circle_filled(sheet, center + Vector2i(8, -4), 8, Color.RED, Color.RED)
    _draw_rect_rounded(sheet, Rect2i(center.x - 8, center.y - 4, 16, 12), Color.RED, 0, Color.RED)

static func _draw_star_icon(sheet: Image, center: Vector2i) -> void:
    var points := []
    for i in range(10):
        var angle := (PI * 2.0 * i) / 10.0
        var radius := 16.0 if i % 2 == 0 else 8.0
        var point := center + Vector2i(int(cos(angle) * radius), int(sin(angle) * radius))
        points.append(point)
    
    for i in range(points.size()):
        var next := (i + 1) % points.size()
        _draw_line_thick(sheet, points[i], points[next], 3, Color.YELLOW)

static func _draw_gear_icon(sheet: Image, center: Vector2i) -> void:
    _draw_circle_filled(sheet, center, 12, Color.GRAY, Color.DARK_GRAY)
    _draw_circle_filled(sheet, center, 5, Color.TRANSPARENT, Color.DARK_GRAY)
    
    for i in range(8):
        var angle := (PI * 2.0 * i) / 8.0
        var x := int(center.x + cos(angle) * 16)
        var y := int(center.y + sin(angle) * 16)
        _draw_rect_rounded(sheet, Rect2i(x - 2, y - 2, 4, 4), Color.GRAY, 1, Color.DARK_GRAY)

static func _draw_arrow_icon(sheet: Image, center: Vector2i, right: bool) -> void:
    if right:
        _draw_line_thick(sheet, center + Vector2i(-16, 0), center + Vector2i(8, 0), 4, Color.WHITE)
        _draw_line_thick(sheet, center + Vector2i(8, 0), center + Vector2i(0, -8), 3, Color.WHITE)
        _draw_line_thick(sheet, center + Vector2i(8, 0), center + Vector2i(0, 8), 3, Color.WHITE)
    else:
        _draw_line_thick(sheet, center + Vector2i(16, 0), center + Vector2i(-8, 0), 4, Color.WHITE)
        _draw_line_thick(sheet, center + Vector2i(-8, 0), center + Vector2i(0, -8), 3, Color.WHITE)
        _draw_line_thick(sheet, center + Vector2i(-8, 0), center + Vector2i(0, 8), 3, Color.WHITE)

static func _draw_check_icon(sheet: Image, center: Vector2i) -> void:
    _draw_line_thick(sheet, center + Vector2i(-12, -8), center + Vector2i(12, 8), 3, Color.GREEN)
    _draw_line_thick(sheet, center + Vector2i(-12, 8), center + Vector2i(12, -8), 3, Color.GREEN)

static func _draw_x_icon(sheet: Image, center: Vector2i) -> void:
    _draw_line_thick(sheet, center + Vector2i(-12, -12), center + Vector2i(12, 12), 3, Color.RED)
    _draw_line_thick(sheet, center + Vector2i(12, -12), center + Vector2i(-12, 12), 3, Color.RED)