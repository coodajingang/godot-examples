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
    stickman_base_texture = StickmanTexture.create_stickman_texture()
    
    # Preload gate textures
    gate_textures["add"] = StickmanTexture.create_gate_texture(Color.GREEN)
    gate_textures["subtract"] = StickmanTexture.create_gate_texture(Color.RED)
    gate_textures["multiply"] = StickmanTexture.create_gate_texture(Color.BLUE)
    gate_textures["divide"] = StickmanTexture.create_gate_texture(Color.ORANGE)
    
    # Preload obstacle textures
    obstacle_textures["barrier"] = StickmanTexture.create_obstacle_texture("barrier")
    obstacle_textures["spike"] = StickmanTexture.create_obstacle_texture("spike")
    obstacle_textures["enemy"] = StickmanTexture.create_obstacle_texture("enemy")

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