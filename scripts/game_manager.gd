extends Node

# Main game controller that orchestrates all systems
# Manages game state, UI, and overall flow

@onready var level_manager: LevelManager = get_node_or_null("LevelManager")
@onready var ui_manager: Control = get_node_or_null("UIManager")
@onready var squad: StickmanSquad = get_node_or_null("StickmanSquad")

var is_game_paused: bool = false
var game_state: GameState = GameState.MENU

enum GameState {
    MENU,
    PLAYING,
    PAUSED,
    GAME_OVER,
    LEVEL_COMPLETE,
    VICTORY
}

func _ready() -> void:
    # Connect to event bus signals
    EventBus.game_started.connect(_on_game_started)
    EventBus.game_paused.connect(_on_game_paused)
    EventBus.game_resumed.connect(_on_game_resumed)
    EventBus.game_over.connect(_on_game_over)
    EventBus.squad_count_changed.connect(_on_squad_count_changed)
    EventBus.score_changed.connect(_on_score_changed)
    
    # Connect to level manager signals
    level_manager.level_completed.connect(_on_level_completed)
    level_manager.all_levels_completed.connect(_on_all_levels_completed)
    
    # Initialize UI
    if ui_manager:
        ui_manager.hide_game_ui()
        ui_manager.show_main_menu()

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        match game_state:
            GameState.PLAYING:
                pause_game()
            GameState.PAUSED:
                resume_game()
            GameState.GAME_OVER, GameState.VICTORY:
                return_to_menu()

func _process(delta: float) -> void:
    if game_state != GameState.PLAYING:
        return
    
    # Handle squad movement
    if squad:
        if Input.is_action_pressed("move_left"):
            squad.move_left()
        if Input.is_action_pressed("move_right"):
            squad.move_right()

func start_new_game() -> void:
    game_state = GameState.PLAYING
    EventBus.start_game()
    
    if ui_manager:
        ui_manager.hide_main_menu()
        ui_manager.show_game_ui()

func pause_game() -> void:
    if game_state == GameState.PLAYING:
        game_state = GameState.PAUSED
        EventBus.pause_game()
        get_tree().paused = true
        
        if ui_manager:
            ui_manager.show_pause_menu()

func resume_game() -> void:
    if game_state == GameState.PAUSED:
        game_state = GameState.PLAYING
        EventBus.resume_game()
        get_tree().paused = false
        
        if ui_manager:
            ui_manager.hide_pause_menu()

func return_to_menu() -> void:
    game_state = GameState.MENU
    get_tree().paused = false
    
    # Reset game state
    EventBus.current_squad_count = 10
    EventBus.current_score = 0
    EventBus.is_game_running = false
    
    if ui_manager:
        ui_manager.hide_all_game_screens()
        ui_manager.show_main_menu()

func _on_game_started() -> void:
    if level_manager and squad:
        level_manager.initialize_level(1, squad)

func _on_game_paused() -> void:
    pass

func _on_game_resumed() -> void:
    pass

func _on_game_over() -> void:
    game_state = GameState.GAME_OVER
    get_tree().paused = false
    
    if ui_manager:
        ui_manager.show_game_over_screen()

func _on_level_completed(level_num: int, score: int) -> void:
    game_state = GameState.LEVEL_COMPLETE
    
    if ui_manager:
        ui_manager.show_level_complete_screen(level_num, score)

func _on_all_levels_completed() -> void:
    game_state = GameState.VICTORY
    get_tree().paused = false
    
    if ui_manager:
        ui_manager.show_victory_screen()

func _on_squad_count_changed(new_count: int, old_count: int) -> void:
    if ui_manager:
        ui_manager.update_squad_count(new_count)

func _on_score_changed(new_score: int) -> void:
    if ui_manager:
        ui_manager.update_score(new_score)