extends Node2D
class_name Stickman

# Individual stickman character
# Handles animation, state, and death effects

signal died(stickman: Stickman)

@export var health: int = 1
@export var move_speed: float = 100.0
@export var color: Color = Color.WHITE

var target_local_position: Vector2 = Vector2.ZERO
var is_alive: bool = true
var current_state: StickmanState = StickmanState.IDLE

enum StickmanState {
    IDLE,
    RUNNING,
    JUMPING,
    FALLING,
    DYING
}

@onready var sprite: Sprite2D = get_node_or_null("Sprite2D")
@onready var animation_player: AnimationPlayer = get_node_or_null("AnimationPlayer")
@onready var collision_shape: CollisionShape2D = get_node_or_null("CollisionShape2D")

func _ready() -> void:
    if sprite:
        sprite.modulate = color
        sprite.texture = ResourceManager.get_stickman_texture()
    _setup_collision()

func _setup_collision() -> void:
    if not collision_shape:
        var shape := CollisionShape2D.new()
        var capsule := CapsuleShape2D.new()
        capsule.height = 20.0
        capsule.radius = 5.0
        shape.shape = capsule
        add_child(shape)
        collision_shape = shape

func _process(delta: float) -> void:
    if not is_alive:
        return
    
    # Smooth movement to target position
    var current_pos := position
    var target_pos := target_local_position
    var distance := current_pos.distance_to(target_pos)
    
    if distance > 0.1:
        position = position.lerp(target_pos, delta * 5.0)
        if current_state != StickmanState.RUNNING:
            set_state(StickmanState.RUNNING)
    else:
        if current_state == StickmanState.RUNNING:
            set_state(StickmanState.IDLE)

func set_state(new_state: StickmanState) -> void:
    if current_state == new_state:
        return
    
    current_state = new_state
    _update_animation()

func _update_animation() -> void:
    if not animation_player:
        return
    
    match current_state:
        StickmanState.IDLE:
            if animation_player.has_animation("idle"):
                animation_player.play("idle")
        StickmanState.RUNNING:
            if animation_player.has_animation("run"):
                animation_player.play("run")
        StickmanState.JUMPING:
            if animation_player.has_animation("jump"):
                animation_player.play("jump")
        StickmanState.FALLING:
            if animation_player.has_animation("fall"):
                animation_player.play("fall")
        StickmanState.DYING:
            if animation_player.has_animation("die"):
                animation_player.play("die")

func take_damage(damage: int) -> void:
    if not is_alive:
        return
    
    health -= damage
    if health <= 0:
        die()

func die() -> void:
    if not is_alive:
        return
    
    is_alive = false
    set_state(StickmanState.DYING)
    died.emit(self)
    
    # Create death effect
    _create_death_effect()
    
    # Remove after animation
    if animation_player and animation_player.has_animation("die"):
        await animation_player.animation_finished
    queue_free()

func _create_death_effect() -> void:
    # Simple particle effect for death
    var particles := CPUParticles2D.new()
    particles.emitting = true
    particles.amount = 10
    particles.lifetime = 0.5
    particles.explosiveness = 1.0
    particles.direction = Vector2.UP
    particles.spread = 45.0
    particles.initial_velocity_min = 50.0
    particles.initial_velocity_max = 100.0
    particles.color = color
    
    get_tree().current_scene.add_child(particles)
    await get_tree().create_timer(1.0).timeout
    particles.queue_free()

func jump() -> void:
    if is_alive and current_state != StickmanState.JUMPING:
        set_state(StickmanState.JUMPING)
        # Add jump physics here if needed

func set_color(new_color: Color) -> void:
    color = new_color
    if sprite:
        sprite.modulate = color