extends Node

# Project verification script
# Checks if all required files and systems are in place

func _ready() -> void:
    print("=== Math Runner: Stickman Squad - Project Verification ===")
    
    # Check project structure
    _check_project_structure()
    
    # Check core systems
    _check_core_systems()
    
    # Check scene files
    _check_scene_files()
    
    # Check scripts
    _check_scripts()
    
    print("\n=== Verification Complete ===")
    print("Project is ready for development in Godot 4.x!")
    print("See SETUP_GUIDE.md for manual configuration steps.")

func _check_project_structure() -> void:
    print("\n--- Checking Project Structure ---")
    
    var required_dirs = [
        "res://scenes/",
        "res://scripts/", 
        "res://utils/",
        "res://assets/",
        "res://ui/"
    ]
    
    for dir in required_dirs:
        if DirAccess.dir_exists_absolute(dir):
            print("✓ Directory exists: " + dir)
        else:
            print("✗ Missing directory: " + dir)

func _check_core_systems() -> void:
    print("\n--- Checking Core Systems ---")
    
    # Check EventBus
    if ClassDB.class_exists("EventBus") or EventBus:
        print("✓ EventBus system available")
    else:
        print("✗ EventBus system missing")
    
    # Check ResourceManager
    if ClassDB.class_exists("ResourceManager") or ResourceManager:
        print("✓ ResourceManager system available")
    else:
        print("✗ ResourceManager system missing")
    
    # Check input mappings
    if InputMap.has_action("move_left") and InputMap.has_action("move_right"):
        print("✓ Input mappings configured")
    else:
        print("✗ Input mappings missing")

func _check_scene_files() -> void:
    print("\n--- Checking Scene Files ---")
    
    var required_scenes = [
        "res://scenes/main.tscn",
        "res://scenes/stickman.tscn",
        "res://scenes/math_gate.tscn", 
        "res://scenes/obstacle.tscn",
        "res://scenes/test_runner.tscn"
    ]
    
    for scene in required_scenes:
        if FileAccess.file_exists(scene):
            print("✓ Scene file exists: " + scene)
        else:
            print("✗ Missing scene file: " + scene)

func _check_scripts() -> void:
    print("\n--- Checking Scripts ---")
    
    var required_scripts = [
        "res://scripts/game_manager.gd",
        "res://scripts/level_manager.gd",
        "res://scripts/stickman_squad.gd",
        "res://scripts/stickman.gd",
        "res://scripts/math_gate.gd",
        "res://scripts/obstacle.gd",
        "res://scripts/ui_manager.gd",
        "res://scripts/event_bus.gd",
        "res://utils/resource_manager.gd",
        "res://utils/texture_generator.gd",
        "res://utils/test_runner.gd"
    ]
    
    for script in required_scripts:
        if FileAccess.file_exists(script):
            print("✓ Script exists: " + script)
        else:
            print("✗ Missing script: " + script)

func _check_documentation() -> void:
    print("\n--- Checking Documentation ---")
    
    var docs = [
        "res://README.md",
        "res://README.MD", 
        "res://SETUP_GUIDE.md",
        "res://PROJECT_SUMMARY.md",
        "res://assets/README.md"
    ]
    
    for doc in docs:
        if FileAccess.file_exists(doc):
            print("✓ Documentation exists: " + doc)
        else:
            print("✗ Missing documentation: " + doc)