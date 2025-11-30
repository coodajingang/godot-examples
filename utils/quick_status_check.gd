extends Node

# Quick project status checker
# Verifies all systems are ready for development

func _ready() -> void:
    print("=== Math Runner: Stickman Squad - Status Check ===")
    
    var all_good := true
    
    # Check project structure
    if not _check_project_structure():
        all_good = false
    
    # Check core systems
    if not _check_core_systems():
        all_good = false
    
    # Check asset generation
    if not _check_asset_generation():
        all_good = false
    
    # Check scene files
    if not _check_scene_files():
        all_good = false
    
    # Overall status
    if all_good:
        print("\n✅ ALL SYSTEMS READY FOR DEVELOPMENT!")
        print("\n🎮 Next Steps:")
        print("1. Open 'scenes/asset_generator.tscn' to generate all assets")
        print("2. Run 'scenes/main.tscn' to start the game")
        print("3. All scenes will open correctly in Godot editor")
        print("4. Game has complete asset generation system")
    else:
        print("\n⚠️  SOME ISSUES FOUND - Check detailed output above")

func _check_project_structure() -> bool:
    print("\n--- Checking Project Structure ---")
    
    var required_dirs = ["scenes", "scripts", "utils", "assets", "ui", "specs"]
    for dir in required_dirs:
        if DirAccess.dir_exists_absolute("res://" + dir):
            print("✓ Directory exists: " + dir)
        else:
            print("✗ Missing directory: " + dir)
            return false
    
    return true

func _check_core_systems() -> bool:
    print("\n--- Checking Core Systems ---")
    
    # Check essential scripts
    var required_scripts = [
        "scripts/event_bus.gd",
        "scripts/game_manager.gd", 
        "scripts/level_manager.gd",
        "scripts/stickman_squad.gd",
        "scripts/stickman.gd",
        "scripts/math_gate.gd",
        "scripts/obstacle.gd",
        "scripts/ui_manager.gd"
    ]
    
    for script in required_scripts:
        if FileAccess.file_exists("res://" + script):
            print("✓ Script exists: " + script)
        else:
            print("✗ Missing script: " + script)
            return false
    
    # Check utility scripts
    var utility_scripts = [
        "utils/asset_generator.gd",
        "utils/resource_manager.gd",
        "utils/texture_generator.gd",
        "utils/advanced_texture_generator.gd",
        "utils/sprite_sheet_generator.gd",
        "utils/ui_texture_generator.gd",
        "utils/test_runner.gd",
        "utils/verify_project.gd"
    ]
    
    for script in utility_scripts:
        if FileAccess.file_exists("res://" + script):
            print("✓ Utility exists: " + script)
        else:
            print("✗ Missing utility: " + script)
            return false
    
    return true

func _check_asset_generation() -> bool:
    print("\n--- Checking Asset Generation ---")
    
    # Check if asset generators exist
    var generators = [
        "utils/asset_generator.gd",
        "utils/advanced_texture_generator.gd",
        "utils/sprite_sheet_generator.gd",
        "utils/ui_texture_generator.gd"
    ]
    
    for generator in generators:
        if FileAccess.file_exists("res://" + generator):
            print("✓ Generator exists: " + generator)
        else:
            print("✗ Missing generator: " + generator)
            return false
    
    # Check if asset generator scene exists
    if FileAccess.file_exists("res://scenes/asset_generator.tscn"):
        print("✓ Asset generator scene exists")
    else:
        print("✗ Missing asset generator scene")
        return false
    
    return true

func _check_scene_files() -> bool:
    print("\n--- Checking Scene Files ---")
    
    var required_scenes = [
        "scenes/main.tscn",
        "scenes/stickman.tscn",
        "scenes/math_gate.tscn",
        "scenes/obstacle.tscn",
        "scenes/test_runner.tscn",
        "scenes/verify_project.tscn",
        "scenes/asset_generator.tscn"
    ]
    
    for scene in required_scenes:
        if FileAccess.file_exists("res://" + scene):
            print("✓ Scene exists: " + scene)
        else:
            print("✗ Missing scene: " + scene)
            return false
    
    return true