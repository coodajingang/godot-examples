# Simple stickman texture using GDScript
# This creates a basic stickman figure programmatically

extends Resource
class_name StickmanTexture

static func create_stickman_texture() -> ImageTexture:
    var image := Image.create(32, 48, false, Image.FORMAT_RGBA8)
    image.fill(Color.TRANSPARENT)
    
    # Draw head (circle)
    var center := Vector2i(16, 8)
    var radius := 4
    for x in range(32):
        for y in range(48):
            var dist := Vector2(x, y).distance_to(center)
            if dist <= radius:
                image.set_pixel(x, y, Color.WHITE)
    
    # Draw body (vertical line)
    for y in range(12, 28):
        image.set_pixel(16, y, Color.WHITE)
    
    # Draw arms (horizontal line)
    for x in range(8, 25):
        image.set_pixel(x, 16, Color.WHITE)
    
    # Draw legs (two lines)
    for y in range(28, 40):
        image.set_pixel(12, y, Color.WHITE)  # Left leg
        image.set_pixel(20, y, Color.WHITE)  # Right leg
    
    return ImageTexture.create_from_image(image)

static func create_gate_texture(color: Color) -> ImageTexture:
    var image := Image.create(80, 120, false, Image.FORMAT_RGBA8)
    image.fill(color)
    
    # Add border
    for x in range(80):
        image.set_pixel(x, 0, Color.WHITE)
        image.set_pixel(x, 119, Color.WHITE)
    for y in range(120):
        image.set_pixel(0, y, Color.WHITE)
        image.set_pixel(79, y, Color.WHITE)
    
    # Add math symbol area
    for x in range(20, 60):
        for y in range(50, 70):
            image.set_pixel(x, y, Color.WHITE)
    
    return ImageTexture.create_from_image(image)

static func create_obstacle_texture(type: String) -> ImageTexture:
    var image := Image.create(40, 40, false, Image.FORMAT_RGBA8)
    
    match type:
        "barrier":
            image.fill(Color.GRAY)
            # Add stripes
            for x in range(0, 40, 4):
                for y in range(40):
                    if (x + y) % 8 < 4:
                        image.set_pixel(x, y, Color.DARK_GRAY)
        "spike":
            image.fill(Color.TRANSPARENT)
            # Draw triangle spike
            for x in range(40):
                for y in range(40):
                    if y < 40 - abs(x - 20):
                        image.set_pixel(x, y, Color.DARK_GRAY)
        "enemy":
            image.fill(Color.RED)
            # Add angry face
            for x in range(12, 18):
                image.set_pixel(x, 12, Color.BLACK)  # Left eye
                image.set_pixel(x + 10, 12, Color.BLACK)  # Right eye
            for x in range(15, 25):
                image.set_pixel(x, 20, Color.BLACK)  # Mouth
        _:
            image.fill(Color.GRAY)
    
    return ImageTexture.create_from_image(image)