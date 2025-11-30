extends Area2D
class_name MathGate

# Mathematical operation gate that modifies squad count
# Players choose which gate to pass through for strategic resource management

signal gate_activated(operation: String, value: int, squad_count_before: int)

@export var operation_type: MathOperation = MathOperation.ADD
@export var operation_value: int = 5
@export var gate_color: Color = Color.BLUE
@export var activation_cooldown: float = 1.0

enum MathOperation {
    ADD,
    SUBTRACT,
    MULTIPLY,
    DIVIDE
}

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var glow_effect: PointLight2D = $PointLight2D

var is_activated: bool = false
var cooldown_timer: float = 0.0
var squad_count_before_activation: int = 0

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    _setup_visuals()
    _setup_collision()

func _setup_visuals() -> void:
    if sprite:
        sprite.modulate = gate_color
        sprite.texture = ResourceManager.get_gate_texture(_get_operation_string())
    
    if label:
        label.text = _get_operation_text()
        label.modulate = Color.WHITE
    
    if glow_effect:
        glow_effect.color = gate_color
        glow_effect.energy = 0.5

func _setup_collision() -> void:
    if not collision_shape:
        var shape := CollisionShape2D.new()
        var rect := RectangleShape2D.new()
        rect.size = Vector2(80, 120)
        shape.shape = rect
        add_child(shape)
        collision_shape = shape

func _get_operation_text() -> String:
    match operation_type:
        MathOperation.ADD:
            return "+%d" % operation_value
        MathOperation.SUBTRACT:
            return "-%d" % operation_value
        MathOperation.MULTIPLY:
            return "×%d" % operation_value
        MathOperation.DIVIDE:
            return "÷%d" % operation_value
        _:
            return "?%d" % operation_value

func _process(delta: float) -> void:
    if cooldown_timer > 0:
        cooldown_timer -= delta
        if cooldown_timer <= 0:
            is_activated = false
            if animation_player and animation_player.has_animation("reset"):
                animation_player.play("reset")
    
    # Visual effects
    if glow_effect:
        var target_energy := 0.5 if not is_activated else 1.5
        glow_effect.energy = lerp(glow_effect.energy, target_energy, delta * 5.0)

func _on_body_entered(body: Node) -> void:
    if is_activated or cooldown_timer > 0:
        return
    
    if body is StickmanSquad:
        _activate_gate(body)

func _activate_gate(squad: StickmanSquad) -> void:
    is_activated = true
    cooldown_timer = activation_cooldown
    squad_count_before_activation = squad.get_squad_count()
    
    # Apply operation to squad
    var result := _apply_operation(squad)
    
    # Visual feedback
    _play_activation_effect()
    
    # Emit signals
    gate_activated.emit(_get_operation_string(), operation_value, squad_count_before_activation)
    EventBus.gate_passed.emit(_get_operation_string(), operation_value)

func _apply_operation(squad: StickmanSquad) -> int:
    var current_count := squad.get_squad_count()
    var new_count := current_count
    
    match operation_type:
        MathOperation.ADD:
            new_count = current_count + operation_value
            for i in operation_value:
                squad.add_member()
        MathOperation.SUBTRACT:
            new_count = max(0, current_count - operation_value)
            squad.remove_member(operation_value)
        MathOperation.MULTIPLY:
            new_count = current_count * operation_value
            var additional := new_count - current_count
            for i in additional:
                squad.add_member()
        MathOperation.DIVIDE:
            if operation_value > 0:
                new_count = int(current_count / operation_value)
                var to_remove := current_count - new_count
                squad.remove_member(to_remove)
    
    EventBus.update_squad_count(new_count)
    return new_count

func _get_operation_string() -> String:
    match operation_type:
        MathOperation.ADD:
            return "add"
        MathOperation.SUBTRACT:
            return "subtract"
        MathOperation.MULTIPLY:
            return "multiply"
        MathOperation.DIVIDE:
            return "divide"
        _:
            return "unknown"

func _play_activation_effect() -> void:
    if animation_player:
        if animation_player.has_animation("activate"):
            animation_player.play("activate")
        else:
            # Create default activation effect
            _create_default_activation_effect()

func _create_default_activation_effect() -> void:
    # Create particle burst
    var particles := CPUParticles2D.new()
    particles.emitting = true
    particles.amount = 20
    particles.lifetime = 1.0
    particles.explosiveness = 0.8
    particles.direction = Vector2.UP
    particles.spread = 180.0
    particles.initial_velocity_min = 100.0
    particles.initial_velocity_max = 200.0
    particles.color = gate_color
    
    add_child(particles)
    await get_tree().create_timer(1.5).timeout
    particles.queue_free()

func set_operation(operation: MathOperation, value: int) -> void:
    operation_type = operation
    operation_value = value
    _setup_visuals()

func get_gate_color_for_operation() -> Color:
    match operation_type:
        MathOperation.ADD:
            return Color.GREEN
        MathOperation.SUBTRACT:
            return Color.RED
        MathOperation.MULTIPLY:
            return Color.BLUE
        MathOperation.DIVIDE:
            return Color.ORANGE
        _:
            return Color.GRAY