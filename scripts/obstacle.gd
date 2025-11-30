extends Area2D
class_name Obstacle

# Obstacles that damage or reduce squad count
# Includes barriers, enemies, traps, and environmental hazards

signal obstacle_hit(damage: int)
signal obstacle_destroyed()

@export var damage: int = 1
@export var obstacle_type: ObstacleType = ObstacleType.BARRIER
@export var move_speed: float = 100.0
@export var health: int = 1
@export var is_destructible: bool = false

enum ObstacleType {
    BARRIER,        # Static barrier
    ENEMY,          # Moving enemy that attacks squad
    TRAP,           # Hidden trap that triggers on contact
    SPIKE,          # Spike obstacle
    MOVING_WALL,    # Wall that moves back and forth
    ZONE            # Damage zone (fire, poison, etc.)
}

@onready var sprite: Sprite2D = get_node_or_null("Sprite2D")
@onready var collision_shape: CollisionShape2D = get_node_or_null("CollisionShape2D")
@onready var animation_player: AnimationPlayer = get_node_or_null("AnimationPlayer")
@onready var hurtbox: Area2D = get_node_or_null("Hurtbox") if has_node("Hurtbox") else null

var is_active: bool = true
var movement_direction: Vector2 = Vector2.LEFT
var original_position: Vector2
var movement_range: float = 100.0

func _ready() -> void:
    original_position = global_position
    body_entered.connect(_on_body_entered)
    
    if hurtbox:
        hurtbox.body_entered.connect(_on_hurtbox_body_entered)
    
    _setup_visuals()
    _setup_collision()
    _setup_movement()

func _setup_visuals() -> void:
    if not sprite:
        return
    
    var texture_name := ""
    match obstacle_type:
        ObstacleType.BARRIER:
            texture_name = "barrier"
            sprite.modulate = Color.GRAY
        ObstacleType.ENEMY:
            texture_name = "enemy"
            sprite.modulate = Color.RED
        ObstacleType.TRAP:
            texture_name = "spike"
            sprite.modulate = Color.DARK_RED
        ObstacleType.SPIKE:
            texture_name = "spike"
            sprite.modulate = Color.DARK_GRAY
        ObstacleType.MOVING_WALL:
            texture_name = "barrier"
            sprite.modulate = Color.BLUE
        ObstacleType.ZONE:
            texture_name = "barrier"
            sprite.modulate = Color.YELLOW
    
    if texture_name != "":
        sprite.texture = ResourceManager.get_obstacle_texture(texture_name)

func _setup_collision() -> void:
    if not collision_shape:
        var shape := CollisionShape2D.new()
        var rect := RectangleShape2D.new()
        
        match obstacle_type:
            ObstacleType.BARRIER, ObstacleType.MOVING_WALL:
                rect.size = Vector2(20, 80)
            ObstacleType.SPIKE:
                rect.size = Vector2(40, 20)
            ObstacleType.ZONE:
                rect.size = Vector2(100, 100)
            _:
                rect.size = Vector2(40, 40)
        
        shape.shape = rect
        add_child(shape)
        collision_shape = shape

func _setup_movement() -> void:
    match obstacle_type:
        ObstacleType.MOVING_WALL:
            movement_direction = Vector2.LEFT
        ObstacleType.ENEMY:
            movement_direction = Vector2.LEFT
        ObstacleType.ZONE:
            # Zones don't move
            movement_direction = Vector2.ZERO
        _:
            movement_direction = Vector2.ZERO

func _process(delta: float) -> void:
    if not is_active:
        return
    
    _handle_movement(delta)

func _handle_movement(delta: float) -> void:
    match obstacle_type:
        ObstacleType.MOVING_WALL:
            _handle_moving_wall(delta)
        ObstacleType.ENEMY:
            _handle_enemy_movement(delta)
        _:
            pass

func _handle_moving_wall(delta: float) -> void:
    var distance := original_position.distance_to(global_position)
    
    if distance >= movement_range:
        movement_direction *= -1
    
    global_position += movement_direction * move_speed * delta

func _handle_enemy_movement(delta: float) -> void:
    # Simple patrol movement
    global_position += movement_direction * move_speed * delta
    
    # Reverse direction at certain distance
    if global_position.x <= original_position.x - movement_range:
        movement_direction = Vector2.RIGHT
    elif global_position.x >= original_position.x + movement_range:
        movement_direction = Vector2.LEFT

func _on_body_entered(body: Node) -> void:
    if not is_active:
        return
    
    if body is StickmanSquad:
        _damage_squad(body)
    elif body is Stickman:
        _damage_stickman(body)

func _on_hurtbox_body_entered(body: Node) -> void:
    if body is StickmanSquad:
        _damage_squad(body)

func _damage_squad(squad: StickmanSquad) -> void:
    if obstacle_type == ObstacleType.ZONE:
        # Continuous damage for zones
        squad.remove_member(damage)
    else:
        # Instant damage for other obstacles
        squad.remove_member(damage)
    
    obstacle_hit.emit(damage)
    EventBus.obstacle_hit.emit(damage)
    
    # Visual feedback
    _play_hit_effect()
    
    # Handle destruction
    if is_destructible:
        health -= 1
        if health <= 0:
            destroy()

func _damage_stickman(stickman: Stickman) -> void:
    stickman.take_damage(damage)
    obstacle_hit.emit(damage)
    _play_hit_effect()

func _play_hit_effect() -> void:
    if animation_player:
        if animation_player.has_animation("hit"):
            animation_player.play("hit")
    
    # Create impact particles
    var particles := CPUParticles2D.new()
    particles.emitting = true
    particles.amount = 10
    particles.lifetime = 0.5
    particles.explosiveness = 1.0
    particles.direction = Vector2.UP
    particles.spread = 45.0
    particles.initial_velocity_min = 50.0
    particles.initial_velocity_max = 100.0
    particles.color = Color.RED
    
    get_tree().current_scene.add_child(particles)
    await get_tree().create_timer(1.0).timeout
    particles.queue_free()

func destroy() -> void:
    is_active = false
    obstacle_destroyed.emit()
    
    if animation_player and animation_player.has_animation("destroy"):
        animation_player.play("destroy")
        await animation_player.animation_finished
    
    queue_free()

func set_obstacle_type(type: ObstacleType) -> void:
    obstacle_type = type
    _setup_visuals()
    _setup_collision()
    _setup_movement()

func disable() -> void:
    is_active = false
    if collision_shape:
        collision_shape.disabled = true

func enable() -> void:
    is_active = true
    if collision_shape:
        collision_shape.disabled = false