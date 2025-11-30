extends Node

# Global event bus for game-wide communication
# Follows Godot best practices for decoupled systems

signal squad_count_changed(new_count: int, old_count: int)
signal gate_passed(gate_type: String, value: int)
signal obstacle_hit(damage: int)
signal level_completed(final_count: int)
signal game_over
signal score_changed(new_score: int)
signal game_started
signal game_paused
signal game_resumed

# Game state management
var current_squad_count: int = 10
var current_score: int = 0
var is_game_running: bool = false
var current_level: int = 1

func _ready() -> void:
    pass

func start_game() -> void:
    is_game_running = true
    current_squad_count = 10
    current_score = 0
    game_started.emit()

func pause_game() -> void:
    if is_game_running:
        is_game_running = false
        game_paused.emit()

func resume_game() -> void:
    if not is_game_running:
        is_game_running = true
        game_resumed.emit()

func update_squad_count(new_count: int) -> void:
    var old_count := current_squad_count
    current_squad_count = max(0, new_count)
    squad_count_changed.emit(current_squad_count, old_count)
    
    if current_squad_count <= 0:
        game_over.emit()

func update_score(points: int) -> void:
    current_score += points
    score_changed.emit(current_score)

func apply_math_operation(operation: String, value: int) -> int:
    var result := current_squad_count
    
    match operation:
        "add":
            result += value
        "subtract":
            result -= value
        "multiply":
            result *= value
        "divide":
            if value > 0:
                result = int(result / value)
        _:
            push_error("Unknown math operation: " + operation)
    
    update_squad_count(result)
    gate_passed.emit(operation, value)
    return result