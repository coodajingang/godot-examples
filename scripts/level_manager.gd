extends Node2D
class_name LevelManager

# Manages level generation, progression, and game flow
# Creates procedural levels with math gates and obstacles

signal level_started(level_number: int)
signal level_completed(level_number: int, final_score: int)
signal all_levels_completed()

@export var level_length: float = 2000.0
@export var gate_spacing: float = 300.0
@export var obstacle_frequency: float = 0.3
@export var base_difficulty: float = 1.0

@onready var camera: Camera2D = get_node_or_null("Camera2D")
@onready var ground: StaticBody2D = get_node_or_null("Ground")
@onready var level_parent: Node2D = get_node_or_null("LevelContent")

var current_level: int = 1
var squad: StickmanSquad
var level_elements: Array[Node] = []
var is_level_active: bool = false
var difficulty_multiplier: float = 1.0

func _ready() -> void:
    EventBus.game_started.connect(_on_game_started)
    EventBus.level_completed.connect(_on_level_completed)
    EventBus.game_over.connect(_on_game_over)

func initialize_level(level_num: int, player_squad: StickmanSquad) -> void:
    current_level = level_num
    squad = player_squad
    difficulty_multiplier = 1.0 + (level_num - 1) * 0.2
    
    clear_level()
    generate_level()
    start_level()

func clear_level() -> void:
    for element in level_elements:
        if is_instance_valid(element):
            element.queue_free()
    level_elements.clear()

func generate_level() -> void:
    # Generate ground
    _generate_ground()
    
    # Generate math gates
    _generate_math_gates()
    
    # Generate obstacles
    _generate_obstacles()
    
    # Generate finish line
    _generate_finish_line()

func _generate_ground() -> void:
    # Create a long ground platform
    var ground_sprite := Sprite2D.new()
    var ground_texture := _create_ground_texture()
    ground_sprite.texture = ground_texture
    ground_sprite.position = Vector2(level_length / 2, 550)
    ground_sprite.centered = false
    
    var ground_collision := CollisionShape2D.new()
    var ground_shape := RectangleShape2D.new()
    ground_shape.size = Vector2(level_length, 100)
    ground_collision.shape = ground_shape
    ground_collision.position = Vector2(level_length / 2, 500)
    
    var ground_body := StaticBody2D.new()
    ground_body.add_child(ground_sprite)
    ground_body.add_child(ground_collision)
    ground_body.position = Vector2.ZERO
    
    level_parent.add_child(ground_body)
    level_elements.append(ground_body)

func _create_ground_texture() -> ImageTexture:
    var image := Image.create(int(level_length), 100, false, Image.FORMAT_RGB8)
    image.fill(Color.DARK_GRAY)
    
    # Add some texture
    for x in range(0, int(level_length), 50):
        for y in range(0, 100, 10):
            if (x / 50 + y / 10) % 2 == 0:
                image.set_pixel(x, y, Color.GRAY)
    
    return ImageTexture.create_from_image(image)

func _generate_math_gates() -> void:
    var gate_positions := _calculate_gate_positions()
    
    for i in range(gate_positions.size()):
        var gate_pos := gate_positions[i]
        var gate := _create_math_gate(i)
        gate.position = gate_pos
        
        level_parent.add_child(gate)
        level_elements.append(gate)

func _calculate_gate_positions() -> Array[Vector2]:
    var positions: Array[Vector2] = []
    var num_gates := int(level_length / gate_spacing)
    
    for i in range(1, num_gates):
        var x := float(i) * gate_spacing
        var y := 400.0 + randf() * 100.0  # Vary height slightly
        positions.append(Vector2(x, y))
    
    return positions

func _create_math_gate(index: int) -> MathGate:
    var gate_scene := preload("res://scenes/math_gate.tscn")
    var gate := gate_scene.instantiate() as MathGate
    
    # Vary operations based on difficulty and level progression
    var operation := _select_gate_operation(index)
    var value := _calculate_gate_value(operation)
    
    gate.set_operation(operation, value)
    gate.gate_color = gate.get_gate_color_for_operation()
    
    return gate

func _select_gate_operation(index: int) -> MathGate.MathOperation:
    var operations := [
        MathGate.MathOperation.ADD,
        MathGate.MathOperation.SUBTRACT,
        MathGate.MathOperation.MULTIPLY,
        MathGate.MathOperation.DIVIDE
    ]
    
    # Early levels favor addition, later levels introduce more complex operations
    if current_level <= 2:
        return MathGate.MathOperation.ADD if randf() > 0.3 else MathGate.MathOperation.SUBTRACT
    elif current_level <= 4:
        return operations.pick_random()
    else:
        # Higher levels have more variety and risk/reward
        var rand := randf()
        if rand < 0.3:
            return MathGate.MathOperation.ADD
        elif rand < 0.5:
            return MathGate.MathOperation.SUBTRACT
        elif rand < 0.75:
            return MathGate.MathOperation.MULTIPLY
        else:
            return MathGate.MathOperation.DIVIDE

func _calculate_gate_value(operation: MathGate.MathOperation) -> int:
    var base_value := int(5 * difficulty_multiplier)
    
    match operation:
        MathGate.MathOperation.ADD:
            return randi_range(base_value, base_value * 2)
        MathGate.MathOperation.SUBTRACT:
            return randi_range(base_value / 2, base_value)
        MathGate.MathOperation.MULTIPLY:
            return randi_range(2, min(5, 2 + current_level / 2))
        MathGate.MathOperation.DIVIDE:
            return randi_range(2, 4)
        _:
            return base_value

func _generate_obstacles() -> void:
    var num_obstacles := int(level_length * obstacle_frequency / 100.0)
    
    for i in range(num_obstacles):
        var obstacle := _create_obstacle()
        var x := randf_range(100.0, level_length - 100.0)
        var y := 350.0 + randf() * 150.0
        obstacle.position = Vector2(x, y)
        
        level_parent.add_child(obstacle)
        level_elements.append(obstacle)

func _create_obstacle() -> Obstacle:
    var obstacle_scene := preload("res://scenes/obstacle.tscn")
    var obstacle := obstacle_scene.instantiate() as Obstacle
    
    # Select obstacle type based on difficulty
    var obstacle_types := [
        Obstacle.ObstacleType.BARRIER,
        Obstacle.ObstacleType.SPIKE,
        Obstacle.ObstacleType.ENEMY,
        Obstacle.ObstacleType.MOVING_WALL
    ]
    
    # Higher levels have more dangerous obstacles
    if current_level <= 2:
        obstacle.set_obstacle_type(obstacle_types[0])  # Just barriers
    elif current_level <= 4:
        obstacle.set_obstacle_type(obstacle_types.pick_random())
    else:
        # Include more complex obstacles
        obstacle.set_obstacle_type(obstacle_types.pick_random())
        obstacle.damage = int(1 + difficulty_multiplier)
        obstacle.is_destructible = randf() > 0.7
    
    return obstacle

func _generate_finish_line() -> void:
    var finish_line := ColorRect.new()
    finish_line.size = Vector2(20, 600)
    finish_line.position = Vector2(level_length - 50, 0)
    finish_line.color = Color.GOLD
    
    var finish_area := Area2D.new()
    var finish_collision := CollisionShape2D.new()
    var finish_shape := RectangleShape2D.new()
    finish_shape.size = Vector2(20, 600)
    finish_collision.shape = finish_shape
    finish_area.add_child(finish_collision)
    finish_area.position = Vector2(level_length - 40, 300)
    finish_area.body_entered.connect(_on_finish_line_reached)
    
    level_parent.add_child(finish_line)
    level_parent.add_child(finish_area)
    level_elements.append(finish_line)
    level_elements.append(finish_area)

func start_level() -> void:
    is_level_active = true
    level_started.emit(current_level)
    
    # Position squad at start
    if squad:
        squad.global_position = Vector2(100, 400)
        squad.initialize_squad(EventBus.current_squad_count)

func _process(delta: float) -> void:
    if not is_level_active or not squad:
        return
    
    # Update camera to follow squad
    if camera:
        var target_x := squad.global_position.x
        camera.global_position.x = lerp(camera.global_position.x, target_x, delta * 5.0)
        camera.global_position.x = clamp(camera.global_position.x, 512, level_length - 512)

func _on_finish_line_reached(body: Node) -> void:
    if body is StickmanSquad and is_level_active:
        complete_level()

func complete_level() -> void:
    is_level_active = false
    
    var final_score := _calculate_final_score()
    EventBus.update_score(final_score)
    level_completed.emit(current_level, final_score)

func _calculate_final_score() -> int:
    var base_score := 1000
    var squad_bonus := EventBus.current_squad_count * 100
    var level_bonus := current_level * 500
    var difficulty_bonus := int(difficulty_multiplier * 200)
    
    return base_score + squad_bonus + level_bonus + difficulty_bonus

func _on_game_started() -> void:
    initialize_level(1, squad)

func _on_level_completed(level_num: int, score: int) -> void:
    # Transition to next level or complete game
    await get_tree().create_timer(2.0).timeout
    
    if level_num < 5:  # 5 levels per game
        initialize_level(level_num + 1, squad)
    else:
        all_levels_completed.emit()

func _on_game_over() -> void:
    is_level_active = false

func get_level_progress() -> float:
    if not squad:
        return 0.0
    return squad.global_position.x / level_length