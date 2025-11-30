extends Resource
class_name UITextureGenerator

# Advanced UI texture generator with modern design elements
# Creates high-quality UI components for the game

# UI color scheme
const UI_COLORS := {
    "primary": Color(0.2, 0.4, 0.8),      # Blue
    "secondary": Color(0.1, 0.6, 0.9),    # Light blue
    "success": Color(0.2, 0.8, 0.3),      # Green
    "warning": Color(0.9, 0.6, 0.2),     # Orange
    "danger": Color(0.9, 0.3, 0.2),       # Red
    "dark": Color(0.1, 0.1, 0.15, 0.95),  # Dark overlay
    "light": Color(0.95, 0.95, 0.95, 0.9),  # Light text
    "gold": Color(1.0, 0.8, 0.2),          # Gold/accent
    "shadow": Color(0.0, 0.0, 0.0, 0.5)     # Shadow
}

# Creates modern button with gradient and effects
static func create_modern_button(state: String, size: Vector2i = Vector2i(120, 40)) -> ImageTexture:
    var image := Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
    image.fill(Color.TRANSPARENT)
    
    var base_color := UI_COLORS.primary
    var text_color := UI_COLORS.light
    
    match state:
        "normal":
            base_color = UI_COLORS.primary
        "hover":
            base_color = UI_COLORS.secondary
        "pressed":
            base_color = Color(0.1, 0.3, 0.7)
        "disabled":
            base_color = Color(0.3, 0.3, 0.3)
    
    # Draw button with gradient
    _draw_button_gradient(image, base_color, size)
    
    # Add button border
    _draw_button_border(image, size)
    
    # Add subtle inner shadow
    _draw_inner_shadow(image, size)
    
    return ImageTexture.create_from_image(image)

# Creates panel with modern styling
static func create_modern_panel(size: Vector2i, style: String = "default") -> ImageTexture:
    var image := Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
    image.fill(Color.TRANSPARENT)
    
    var bg_color := UI_COLORS.dark
    var border_color := UI_COLORS.primary
    
    match style:
        "dark":
            bg_color = Color(0.05, 0.05, 0.1, 0.95)
            border_color = Color(0.2, 0.4, 0.8)
        "light":
            bg_color = Color(0.9, 0.9, 0.95, 0.8)
            border_color = Color(0.7, 0.7, 0.8)
    
    # Draw panel background with subtle gradient
    _draw_panel_background(image, bg_color, size)
    
    # Draw panel border with rounded corners
    _draw_rounded_border(image, border_color, size)
    
    # Add corner highlights
    _draw_corner_highlights(image, border_color, size)
    
    return ImageTexture.create_from_image(image)

# Creates progress bar with modern styling
static func create_progress_bar(size: Vector2i = Vector2i(200, 20)) -> ImageTexture:
    var image := Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
    image.fill(Color.TRANSPARENT)
    
    # Background
    _draw_rounded_rect(image, Rect2i(0, 0, size.x, size.y), UI_COLORS.dark, 4, Color(0.3, 0.3, 0.4))
    
    # Progress fill (animated effect)
    var fill_width := size.x - 8
    _draw_progress_fill(image, fill_width, size.y)
    
    # Border
    _draw_rounded_border(image, UI_COLORS.primary, size)
    
    return ImageTexture.create_from_image(image)

# Creates health bar with heart icons
static func create_health_bar(max_hearts: int = 5) -> ImageTexture:
    var heart_size := 16
    var spacing := 4
    var total_width := max_hearts * (heart_size + spacing)
    var image := Image.create(total_width, heart_size, false, Image.FORMAT_RGBA8)
    image.fill(Color.TRANSPARENT)
    
    for i in range(max_hearts):
        var x := i * (heart_size + spacing)
        var heart_color := UI_COLORS.success if i < 3 else UI_COLORS.dark
        _draw_heart(image, Vector2i(x, 0), heart_size, heart_color)
    
    return ImageTexture.create_from_image(image)

# Creates icon set for various UI elements
static func create_icon_set() -> Dictionary:
    var icons := {}
    var icon_types := ["play", "pause", "restart", "menu", "settings", "sound_on", "sound_off", "fullscreen", "windowed"]
    
    for icon_type in icon_types:
        icons[icon_type] = _create_detailed_icon(icon_type)
    
    return icons

# Creates animated loading spinner
static func create_loading_spinner(size: int = 32) -> ImageTexture:
    var image := Image.create(size, size, false, Image.FORMAT_RGBA8)
    image.fill(Color.TRANSPARENT)
    
    # Draw circular segments for spinner
    var segments := 8
    for i in range(segments):
        var angle := (PI * 2.0 * i) / segments
        var next_angle := (PI * 2.0 * (i + 1)) / segments
        
        # Calculate segment points
        var inner_radius := size / 4
        var outer_radius := size / 2 - 2
        
        var p1 := Vector2(size/2, size/2) + Vector2(cos(angle) * inner_radius, sin(angle) * inner_radius)
        var p2 := Vector2(size/2, size/2) + Vector2(cos(angle) * outer_radius, sin(angle) * outer_radius)
        var p3 := Vector2(size/2, size/2) + Vector2(cos(next_angle) * outer_radius, sin(next_angle) * outer_radius)
        
        # Draw segment
        _draw_triangle(image, p1, p2, p3, UI_COLORS.primary)
    
    return ImageTexture.create_from_image(image)

# Helper drawing functions
static func _draw_button_gradient(image: Image, color: Color, size: Vector2i) -> void:
    # Create vertical gradient
    for y in range(size.y):
        var t := float(y) / float(size.y)
        var gradient_color := color.lerp(Color(color.r * 1.2, color.g * 1.2, color.b * 1.2), t * 0.3)
        
        for x in range(4, size.x - 4):
            _set_pixel_safe(image, Vector2i(x, y), gradient_color)

static func _draw_button_border(image: Image, size: Vector2i) -> void:
    # Outer border
    _draw_rounded_rect(image, Rect2i(0, 0, size.x, size.y), Color.TRANSPARENT, 3, UI_COLORS.primary)
    
    # Inner highlight
    var highlight_color := Color(UI_COLORS.primary.r * 1.3, UI_COLORS.primary.g * 1.3, UI_COLORS.primary.b * 1.3)
    _draw_rounded_rect(image, Rect2i(2, 2, size.x - 4, size.y - 4), Color.TRANSPARENT, 2, highlight_color)

static func _draw_inner_shadow(image: Image, size: Vector2i) -> void:
    # Subtle inner shadow for depth
    var shadow_rect := Rect2i(4, 4, size.x - 8, size.y - 8)
    for x in range(shadow_rect.position.x, shadow_rect.position.x + shadow_rect.size.x):
        for y in range(shadow_rect.position.y, shadow_rect.position.y + shadow_rect.size.y):
            var shadow_color := Color(0, 0, 0, 0.2)
            _set_pixel_safe(image, Vector2i(x + 1, y + 1), shadow_color)

static func _draw_panel_background(image: Image, color: Color, size: Vector2i) -> void:
    # Subtle gradient background
    for y in range(size.y):
        var t := float(y) / float(size.y)
        var bg_color := color.lerp(Color(color.r * 0.8, color.g * 0.8, color.b * 0.8), t * 0.1)
        
        for x in range(4, size.x - 4):
            _set_pixel_safe(image, Vector2i(x, y), bg_color)

static func _draw_rounded_border(image: Image, color: Color, size: Vector2i) -> void:
    # Draw rounded rectangle border
    _draw_rounded_rect(image, Rect2i(0, 0, size.x, size.y), Color.TRANSPARENT, 3, color)
    
    # Add corner highlights
    var highlight_color := Color(color.r * 1.4, color.g * 1.4, color.b * 1.4)
    var corner_size := 3
    
    # Top-left corner
    for x in range(corner_size):
        for y in range(corner_size):
            _set_pixel_safe(image, Vector2i(x + 1, y + 1), highlight_color)
    
    # Top-right corner
    for x in range(corner_size):
        for y in range(corner_size):
            _set_pixel_safe(image, Vector2i(size.x - corner_size + x - 1, y + 1), highlight_color)
    
    # Bottom-left corner
    for x in range(corner_size):
        for y in range(corner_size):
            _set_pixel_safe(image, Vector2i(x + 1, size.y - corner_size + y - 1), highlight_color)
    
    # Bottom-right corner
    for x in range(corner_size):
        for y in range(corner_size):
            _set_pixel_safe(image, Vector2i(size.x - corner_size + x - 1, size.y - corner_size + y - 1), highlight_color)

static func _draw_progress_fill(image: Image, width: int, height: int) -> void:
    # Animated fill with gradient
    for y in range(4, height - 4):
        var t := float(y - 4) / float(height - 8)
        var fill_color := UI_COLORS.success.lerp(UI_COLORS.warning, t)
        
        for x in range(4, width + 4):
            _set_pixel_safe(image, Vector2i(x, y), fill_color)

static func _draw_heart(image: Image, pos: Vector2i, size: int, color: Color) -> void:
    # Draw pixel heart shape
    var heart_points := [
        Vector2(pos.x + size/2, pos.y + size/4),
        Vector2(pos.x + size/4, pos.y),
        Vector2(pos.x + size*3/4, pos.y + size/4),
        Vector2(pos.x + size, pos.y + size/2),
        Vector2(pos.x + size*3/4, pos.y + size*3/4),
        Vector2(pos.x + size/2, pos.y + size),
        Vector2(pos.x + size/4, pos.y + size*3/4),
        Vector2(pos.x, pos.y + size/2)
    ]
    
    # Fill heart shape (simplified)
    for x in range(pos.x, pos.x + size):
        for y in range(pos.y, pos.y + size):
            if _point_in_heart(Vector2i(x, y), pos, size):
                _set_pixel_safe(image, Vector2i(x, y), color)

static func _point_in_heart(point: Vector2i, pos: Vector2i, size: int) -> bool:
    # Simplified heart shape test
    var rel_x := point.x - pos.x
    var rel_y := point.y - pos.y
    var center_x := size / 2
    var center_y := size / 2
    
    # Basic heart shape (circle with top indentation)
    if rel_y < center_y:
        var dist := Vector2(rel_x - center_x, rel_y - center_y).length()
        return dist <= size / 3
    else:
        dist := Vector2(rel_x - center_x, rel_y - center_y).length()
        return dist <= size / 2.5

static func _create_detailed_icon(icon_type: String) -> ImageTexture:
    var image := Image.create(24, 24, false, Image.FORMAT_RGBA8)
    image.fill(Color.TRANSPARENT)
    
    match icon_type:
        "play":
            _draw_play_icon(image)
        "pause":
            _draw_pause_icon(image)
        "restart":
            _draw_restart_icon(image)
        "menu":
            _draw_menu_icon(image)
        "settings":
            _draw_settings_icon(image)
        "sound_on":
            _draw_sound_icon(image, true)
        "sound_off":
            _draw_sound_icon(image, false)
        "fullscreen":
            _draw_fullscreen_icon(image)
        "windowed":
            _draw_windowed_icon(image)
        _:
            _draw_default_icon(image)
    
    return ImageTexture.create_from_image(image)

# Individual icon drawing functions
static func _draw_play_icon(image: Image) -> void:
    var center := Vector2i(12, 12)
    _draw_triangle(image, center + Vector2i(-6, -4), center + Vector2i(0, 6), center + Vector2i(6, -4), UI_COLORS.success)

static func _draw_pause_icon(image: Image) -> void:
    var center := Vector2i(12, 12)
    _draw_rect_rounded(image, Rect2i(center.x - 6, center.y - 6, 12, 12), UI_COLORS.warning, 2, UI_COLORS.light)

static func _draw_restart_icon(image: Image) -> void:
    var center := Vector2i(12, 12)
    # Circular arrow
    _draw_circle_filled(image, center, 8, UI_COLORS.primary, UI_COLORS.light)
    _draw_triangle(image, center + Vector2i(0, -4), center + Vector2i(-3, 0), center + Vector2i(3, 0), UI_COLORS.light)

static func _draw_menu_icon(image: Image) -> void:
    var center := Vector2i(12, 12)
    # Three horizontal lines
    for i in range(3):
        var y := center.y - 4 + i * 4
        _draw_rect_rounded(image, Rect2i(center.x - 6, y, 12, 2), UI_COLORS.primary, 1, UI_COLORS.light)

static func _draw_settings_icon(image: Image) -> void:
    var center := Vector2i(12, 12)
    # Gear shape
    _draw_circle_filled(image, center, 6, UI_COLORS.primary, UI_COLORS.dark)
    _draw_circle_filled(image, center, 3, UI_COLORS.dark, UI_COLORS.dark)
    
    # Gear teeth
    for i in range(6):
        var angle := (PI * 2.0 * i) / 6.0
        var x := center.x + int(cos(angle) * 8)
        var y := center.y + int(sin(angle) * 8)
        _draw_rect_rounded(image, Rect2i(x - 2, y - 2, 4, 4), UI_COLORS.primary, 0, UI_COLORS.primary)

static func _draw_sound_icon(image: Image, is_on: bool) -> void:
    var center := Vector2i(12, 12)
    var color := UI_COLORS.success if is_on else UI_COLORS.dark
    
    # Speaker shape
    _draw_rect_rounded(image, Rect2i(center.x - 6, center.y - 4, 12, 8), color, 2, UI_COLORS.light)
    
    if is_on:
        # Sound waves
        for i in range(3):
            _draw_rect_rounded(image, Rect2i(center.x + 8 + i * 3, center.y - 2 + i * 2, 2, 1), color, 0, color)

static func _draw_fullscreen_icon(image: Image) -> void:
    var center := Vector2i(12, 12)
    # Fullscreen rectangle
    _draw_rect_rounded(image, Rect2i(center.x - 8, center.y - 6, 16, 12), UI_COLORS.primary, 2, UI_COLORS.light)
    
    # Corner indicators
    _draw_rect_rounded(image, Rect2i(center.x - 8, center.y - 6, 3, 3), UI_COLORS.success, 0, UI_COLORS.success)
    _draw_rect_rounded(image, Rect2i(center.x + 5, center.y - 6, 3, 3), UI_COLORS.success, 0, UI_COLORS.success)
    _draw_rect_rounded(image, Rect2i(center.x - 8, center.y + 3, 3, 3), UI_COLORS.success, 0, UI_COLORS.success)
    _draw_rect_rounded(image, Rect2i(center.x + 5, center.y + 3, 3, 3), UI_COLORS.success, 0, UI_COLORS.success)

static func _draw_windowed_icon(image: Image) -> void:
    var center := Vector2i(12, 12)
    # Windowed rectangles
    _draw_rect_rounded(image, Rect2i(center.x - 8, center.y - 6, 7, 6), UI_COLORS.primary, 2, UI_COLORS.light)
    _draw_rect_rounded(image, Rect2i(center.x + 1, center.y - 6, 7, 6), UI_COLORS.primary, 2, UI_COLORS.light)

static func _draw_default_icon(image: Image) -> void:
    var center := Vector2i(12, 12)
    _draw_circle_filled(image, center, 8, UI_COLORS.primary, UI_COLORS.light)

# Geometric shape drawing functions
static func _draw_rounded_rect(image: Image, rect: Rect2i, fill_color: Color, border: int, border_color: Color) -> void:
    # Fill
    for x in range(rect.position.x + border, rect.position.x + rect.size.x - border):
        for y in range(rect.position.y + border, rect.position.y + rect.size.y - border):
            _set_pixel_safe(image, Vector2i(x, y), fill_color)
    
    # Border
    for i in range(border):
        for x in range(rect.position.x, rect.position.x + rect.size.x):
            _set_pixel_safe(image, Vector2i(x, rect.position.y + i), border_color)
            _set_pixel_safe(image, Vector2i(x, rect.position.y + rect.size.y - 1 - i), border_color)
        
        for y in range(rect.position.y, rect.position.y + rect.size.y):
            _set_pixel_safe(image, Vector2i(rect.position.x + i, y), border_color)
            _set_pixel_safe(image, Vector2i(rect.position.x + rect.size.x - 1 - i, y), border_color)

static func _draw_triangle(image: Image, p1: Vector2i, p2: Vector2i, p3: Vector2i, color: Color) -> void:
    # Fill triangle using scanline algorithm
    var min_y := min(p1.y, p2.y, p3.y)
    var max_y := max(p1.y, p2.y, p3.y)
    
    for y in range(min_y, max_y + 1):
        var intersections := []
        
        # Find intersections with this scanline
        if _line_intersects_y(p1, p2, y):
            intersections.append(_get_x_at_y(p1, p2, y))
        if _line_intersects_y(p2, p3, y):
            intersections.append(_get_x_at_y(p2, p3, y))
        if _line_intersects_y(p3, p1, y):
            intersections.append(_get_x_at_y(p3, p1, y))
        
        # Sort and fill between intersections
        if intersections.size() > 0:
            intersections.sort()
            for i in range(0, intersections.size() - 1, 2):
                var start_x := intersections[i]
                var end_x := intersections[i + 1]
                for x in range(start_x, end_x + 1):
                    _set_pixel_safe(image, Vector2i(x, y), color)

static func _line_intersects_y(p1: Vector2i, p2: Vector2i, y: int) -> bool:
    return (p1.y <= y and p2.y >= y) or (p2.y <= y and p1.y >= y)

static func _get_x_at_y(p1: Vector2i, p2: Vector2i, y: int) -> int:
    if p1.y == p2.y:
        return p1.x
    
    var t := float(y - p1.y) / float(p2.y - p1.y)
    return int(p1.x + t * (p2.x - p1.x))

static func _set_pixel_safe(image: Image, pos: Vector2i, color: Color) -> void:
    if pos.x >= 0 and pos.x < image.get_width() and pos.y >= 0 and pos.y < image.get_height():
        image.set_pixel(pos.x, pos.y, color)