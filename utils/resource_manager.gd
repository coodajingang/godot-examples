extends Node
class_name ResourceManager

# Centralized resource management
# Handles loading and caching of game assets

var cached_textures: Dictionary = {}
var stickman_base_texture: ImageTexture
var gate_textures: Dictionary = {}
var obstacle_textures: Dictionary = {}

func _ready() -> void:
    _preload_textures()

func _preload_textures() -> void:
    # Preload stickman texture
    if ClassDB.class_exists("AdvancedTextureGenerator"):
        stickman_base_texture = AdvancedTextureGenerator.create_detailed_stickman_texture()
    elif ClassDB.class_exists("StickmanTexture"):
        stickman_base_texture = StickmanTexture.create_stickman_texture()
    else:
        # Create a simple fallback texture
        stickman_base_texture = _create_fallback_texture(Color.WHITE, 32, 48)
    
    # Preload gate textures
    if ClassDB.class_exists("AdvancedTextureGenerator"):
        gate_textures["add"] = AdvancedTextureGenerator.create_detailed_gate_texture("add")
        gate_textures["subtract"] = AdvancedTextureGenerator.create_detailed_gate_texture("subtract")
        gate_textures["multiply"] = AdvancedTextureGenerator.create_detailed_gate_texture("multiply")
        gate_textures["divide"] = AdvancedTextureGenerator.create_detailed_gate_texture("divide")
    elif ClassDB.class_exists("StickmanTexture"):
        gate_textures["add"] = StickmanTexture.create_gate_texture(Color.GREEN)
        gate_textures["subtract"] = StickmanTexture.create_gate_texture(Color.RED)
        gate_textures["multiply"] = StickmanTexture.create_gate_texture(Color.BLUE)
        gate_textures["divide"] = StickmanTexture.create_gate_texture(Color.ORANGE)
    else:
        # Create fallback gate textures
        gate_textures["add"] = _create_fallback_texture(Color.GREEN, 80, 120)
        gate_textures["subtract"] = _create_fallback_texture(Color.RED, 80, 120)
        gate_textures["multiply"] = _create_fallback_texture(Color.BLUE, 80, 120)
        gate_textures["divide"] = _create_fallback_texture(Color.ORANGE, 80, 120)
    
    # Preload obstacle textures
    if ClassDB.class_exists("AdvancedTextureGenerator"):
        obstacle_textures["barrier"] = AdvancedTextureGenerator.create_detailed_obstacle_texture("barrier")
        obstacle_textures["spike"] = AdvancedTextureGenerator.create_detailed_obstacle_texture("spike")
        obstacle_textures["enemy"] = AdvancedTextureGenerator.create_detailed_obstacle_texture("enemy")
        obstacle_textures["zone"] = AdvancedTextureGenerator.create_detailed_obstacle_texture("zone")
    elif ClassDB.class_exists("StickmanTexture"):
        obstacle_textures["barrier"] = StickmanTexture.create_obstacle_texture("barrier")
        obstacle_textures["spike"] = StickmanTexture.create_obstacle_texture("spike")
        obstacle_textures["enemy"] = StickmanTexture.create_obstacle_texture("enemy")
    else:
        # Create fallback obstacle textures
        obstacle_textures["barrier"] = _create_fallback_texture(Color.GRAY, 40, 40)
        obstacle_textures["spike"] = _create_fallback_texture(Color.DARK_GRAY, 40, 40)
        obstacle_textures["enemy"] = _create_fallback_texture(Color.RED, 40, 40)
        obstacle_textures["zone"] = _create_fallback_texture(Color.ORANGE, 40, 40)

func _create_fallback_texture(color: Color, width: int, height: int) -> ImageTexture:
    var image := Image.create(width, height, false, Image.FORMAT_RGBA8)
    image.fill(color)
    return ImageTexture.create_from_image(image)

func get_stickman_texture() -> ImageTexture:
    return stickman_base_texture

func get_gate_texture(operation: String) -> ImageTexture:
    if operation in gate_textures:
        return gate_textures[operation]
    return gate_textures["add"]  # Default

func get_obstacle_texture(type: String) -> ImageTexture:
    if type in obstacle_textures:
        return obstacle_textures[type]
    return obstacle_textures["barrier"]  # Default