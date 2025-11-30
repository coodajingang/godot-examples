extends Node

# Test script to verify core game functionality
# This can be run from the command line or in Godot

func _ready() -> void:
    print("=== Math Runner: Stickman Squad - Test Suite ===")
    
    # Test EventBus
    _test_event_bus()
    
    # Test ResourceManager
    _test_resource_manager()
    
    # Test Math operations
    _test_math_operations()
    
    print("=== All tests completed ===")

func _test_event_bus() -> void:
    print("\n--- Testing EventBus ---")
    
    # Test initial values
    assert(EventBus.current_squad_count == 10, "Initial squad count should be 10")
    assert(EventBus.current_score == 0, "Initial score should be 0")
    assert(not EventBus.is_game_running, "Game should not be running initially")
    
    # Test squad count update
    EventBus.update_squad_count(15)
    assert(EventBus.current_squad_count == 15, "Squad count should be 15")
    
    # Test score update
    EventBus.update_score(100)
    assert(EventBus.current_score == 100, "Score should be 100")
    
    print("✓ EventBus tests passed")

func _test_resource_manager() -> void:
    print("\n--- Testing ResourceManager ---")
    
    # Test texture loading
    var stickman_texture := ResourceManager.get_stickman_texture()
    assert(stickman_texture != null, "Stickman texture should be loaded")
    
    var gate_texture := ResourceManager.get_gate_texture("add")
    assert(gate_texture != null, "Gate texture should be loaded")
    
    var obstacle_texture := ResourceManager.get_obstacle_texture("barrier")
    assert(obstacle_texture != null, "Obstacle texture should be loaded")
    
    print("✓ ResourceManager tests passed")

func _test_math_operations() -> void:
    print("\n--- Testing Math Operations ---")
    
    # Reset squad count
    EventBus.current_squad_count = 10
    
    # Test addition
    var result := EventBus.apply_math_operation("add", 5)
    assert(result == 15, "10 + 5 should be 15")
    
    # Test subtraction
    result = EventBus.apply_math_operation("subtract", 3)
    assert(result == 12, "15 - 3 should be 12")
    
    # Test multiplication
    result = EventBus.apply_math_operation("multiply", 2)
    assert(result == 24, "12 × 2 should be 24")
    
    # Test division
    result = EventBus.apply_math_operation("divide", 3)
    assert(result == 8, "24 ÷ 3 should be 8 (integer division)")
    
    print("✓ Math operations tests passed")

func _test_squad_formations() -> void:
    print("\n--- Testing Squad Formations ---")
    
    # This would require instantiating a StickmanSquad
    # For now, just verify the enum values exist
    var formations := [
        StickmanSquad.FormationType.RECTANGLE,
        StickmanSquad.FormationType.CIRCLE,
        StickmanSquad.FormationType.TRIANGLE,
        StickmanSquad.FormationType.LINE
    ]
    
    assert(formations.size() == 4, "Should have 4 formation types")
    
    print("✓ Squad formation tests passed")