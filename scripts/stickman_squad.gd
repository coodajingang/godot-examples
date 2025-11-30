extends Node2D
class_name StickmanSquad

# Manages the stickman squad - the player's main resource
# Handles formation, movement, and visual representation

signal squad_member_died(member: Stickman)
signal formation_changed()

@export var max_squad_size: int = 100
@export var squad_spacing: float = 15.0
@export var move_speed: float = 200.0
@export var formation_width: int = 5

var squad_members: Array[Stickman] = []
var target_position: Vector2
var current_formation_type: FormationType = FormationType.RECTANGLE

enum FormationType {
    RECTANGLE,
    CIRCLE,
    TRIANGLE,
    LINE
}

func _ready() -> void:
    target_position = global_position

func initialize_squad(count: int) -> void:
    clear_squad()
    for i in count:
        add_member()

func clear_squad() -> void:
    for member in squad_members:
        if is_instance_valid(member):
            member.queue_free()
    squad_members.clear()

func add_member() -> void:
    if squad_members.size() >= max_squad_size:
        return
    
    var member := preload("res://scenes/stickman.tscn").instantiate() as Stickman
    add_child(member)
    squad_members.append(member)
    update_formation()

func remove_member(count: int = 1) -> void:
    var removed := 0
    var members_to_remove: Array[Stickman] = []
    
    # Remove from the back (least important members first)
    for i in range(squad_members.size() - 1, -1, -1):
        if removed >= count:
            break
        members_to_remove.append(squad_members[i])
        removed += 1
    
    for member in members_to_remove:
        squad_members.erase(member)
        if is_instance_valid(member):
            member.die()
        squad_member_died.emit(member)
    
    update_formation()

func update_formation() -> void:
    var member_count := squad_members.size()
    
    match current_formation_type:
        FormationType.RECTANGLE:
            _apply_rectangle_formation(member_count)
        FormationType.CIRCLE:
            _apply_circle_formation(member_count)
        FormationType.TRIANGLE:
            _apply_triangle_formation(member_count)
        FormationType.LINE:
            _apply_line_formation(member_count)
    
    formation_changed.emit()

func _apply_rectangle_formation(count: int) -> void:
    var cols := min(formation_width, count)
    var rows := ceil(count / float(cols))
    
    for i in count:
        var row := int(i / cols)
        var col := i % cols
        var target_x := (col - cols / 2.0) * squad_spacing
        var target_y := row * squad_spacing
        
        if i < squad_members.size():
            squad_members[i].target_local_position = Vector2(target_x, target_y)

func _apply_circle_formation(count: int) -> void:
    if count == 0:
        return
    
    var radius := squad_spacing * sqrt(count) / 2.0
    
    for i in count:
        var angle := (PI * 2.0 * i) / count
        var target_x := cos(angle) * radius
        var target_y := sin(angle) * radius
        
        if i < squad_members.size():
            squad_members[i].target_local_position = Vector2(target_x, target_y)

func _apply_triangle_formation(count: int) -> void:
    var row_sizes := []
    var remaining := count
    var row := 1
    
    while remaining > 0:
        var size := min(row, remaining)
        row_sizes.append(size)
        remaining -= size
        row += 1
    
    var member_index := 0
    for r in range(row_sizes.size()):
        var row_size := row_sizes[r]
        var row_width := row_size * squad_spacing
        
        for c in range(row_size):
            var target_x := (c - row_size / 2.0 + 0.5) * squad_spacing
            var target_y := r * squad_spacing
            
            if member_index < squad_members.size():
                squad_members[member_index].target_local_position = Vector2(target_x, target_y)
            member_index += 1

func _apply_line_formation(count: int) -> void:
    for i in count:
        var target_x := (i - count / 2.0) * squad_spacing
        var target_y := 0.0
        
        if i < squad_members.size():
            squad_members[i].target_local_position = Vector2(target_x, target_y)

func _process(delta: float) -> void:
    # Move squad towards target position
    var direction := (target_position - global_position).normalized()
    var distance := target_position.distance_to(global_position)
    
    if distance > 1.0:
        global_position += direction * move_speed * delta
    
    # Update member positions
    for member in squad_members:
        if is_instance_valid(member):
            member.global_position = global_position + member.target_local_position

func move_left() -> void:
    target_position.x -= move_speed * 0.1

func move_right() -> void:
    target_position.x += move_speed * 0.1

func set_formation(formation: FormationType) -> void:
    current_formation_type = formation
    update_formation()

func get_squad_count() -> int:
    return squad_members.size()