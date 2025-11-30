extends Control
class_name UIManager

# Manages all UI elements and displays game information
# Follows Godot best practices for UI separation

@onready var main_menu: VBoxContainer = $MainMenu
@onready var game_ui: HBoxContainer = $GameUI
@onready var pause_menu: VBoxContainer = $PauseMenu
@onready var game_over_screen: VBoxContainer = $GameOverScreen
@onready var level_complete_screen: VBoxContainer = $LevelCompleteScreen
@onready var victory_screen: VBoxContainer = $VictoryScreen

@onready var squad_count_label: Label = $GameUI/SquadCountLabel
@onready var score_label: Label = $GameUI/ScoreLabel
@onready var level_label: Label = $GameUI/LevelLabel
@onready var progress_bar: ProgressBar = $GameUI/ProgressBar

@onready var start_button: Button = $MainMenu/StartButton
@onready var resume_button: Button = $PauseMenu/ResumeButton
@onready var restart_button: Button = $PauseMenu/RestartButton
@onready var menu_button: Button = $PauseMenu/MenuButton

@onready var final_score_label: Label = $GameOverScreen/FinalScoreLabel
@onready var restart_game_over_button: Button = $GameOverScreen/RestartButton

@onready var level_complete_label: Label = $LevelCompleteScreen/LevelCompleteLabel
@onready var level_score_label: Label = $LevelCompleteScreen/LevelScoreLabel
@onready var continue_button: Button = $LevelCompleteScreen/ContinueButton

@onready var victory_score_label: Label = $VictoryScreen/VictoryScoreLabel
@onready var play_again_button: Button = $VictoryScreen/PlayAgainButton

func _ready() -> void:
    _setup_ui()
    _connect_signals()

func _setup_ui() -> void:
    # Set initial UI state
    hide_all_game_screens()
    show_main_menu()
    
    # Style buttons
    _style_button(start_button)
    _style_button(resume_button)
    _style_button(restart_button)
    _style_button(menu_button)
    _style_button(restart_game_over_button)
    _style_button(continue_button)
    _style_button(play_again_button)

func _style_button(button: Button) -> void:
    if not button:
        return
    
    # Create button style
    var style := StyleBoxFlat.new()
    style.bg_color = Color.BLUE
    style.border_width_left = 2
    style.border_width_right = 2
    style.border_width_top = 2
    style.border_width_bottom = 2
    style.border_color = Color.WHITE
    style.corner_radius_top_left = 5
    style.corner_radius_top_right = 5
    style.corner_radius_bottom_left = 5
    style.corner_radius_bottom_right = 5
    
    button.add_theme_stylebox_override("normal", style)
    
    var hover_style := style.duplicate()
    hover_style.bg_color = Color.CYAN
    button.add_theme_stylebox_override("hover", hover_style)
    
    var pressed_style := style.duplicate()
    pressed_style.bg_color = Color.DARK_BLUE
    button.add_theme_stylebox_override("pressed", pressed_style)

func _connect_signals() -> void:
    if start_button:
        start_button.pressed.connect(_on_start_pressed)
    
    if resume_button:
        resume_button.pressed.connect(_on_resume_pressed)
    
    if restart_button:
        restart_button.pressed.connect(_on_restart_pressed)
    
    if menu_button:
        menu_button.pressed.connect(_on_menu_pressed)
    
    if restart_game_over_button:
        restart_game_over_button.pressed.connect(_on_restart_pressed)
    
    if continue_button:
        continue_button.pressed.connect(_on_continue_pressed)
    
    if play_again_button:
        play_again_button.pressed.connect(_on_play_again_pressed)

func show_main_menu() -> void:
    if main_menu:
        main_menu.visible = true

func hide_main_menu() -> void:
    if main_menu:
        main_menu.visible = false

func show_game_ui() -> void:
    if game_ui:
        game_ui.visible = true

func hide_game_ui() -> void:
    if game_ui:
        game_ui.visible = false

func show_pause_menu() -> void:
    if pause_menu:
        pause_menu.visible = true

func hide_pause_menu() -> void:
    if pause_menu:
        pause_menu.visible = false

func show_game_over_screen() -> void:
    if game_over_screen:
        game_over_screen.visible = true
        if final_score_label:
            final_score_label.text = "Final Score: %d" % EventBus.current_score

func hide_game_over_screen() -> void:
    if game_over_screen:
        game_over_screen.visible = false

func show_level_complete_screen(level: int, score: int) -> void:
    if level_complete_screen:
        level_complete_screen.visible = true
        if level_complete_label:
            level_complete_label.text = "Level %d Complete!" % level
        if level_score_label:
            level_score_label.text = "Score: %d" % score

func hide_level_complete_screen() -> void:
    if level_complete_screen:
        level_complete_screen.visible = false

func show_victory_screen() -> void:
    if victory_screen:
        victory_screen.visible = true
        if victory_score_label:
            victory_score_label.text = "Victory! Final Score: %d" % EventBus.current_score

func hide_victory_screen() -> void:
    if victory_screen:
        victory_screen.visible = false

func hide_all_game_screens() -> void:
    hide_main_menu()
    hide_game_ui()
    hide_pause_menu()
    hide_game_over_screen()
    hide_level_complete_screen()
    hide_victory_screen()

func update_squad_count(count: int) -> void:
    if squad_count_label:
        squad_count_label.text = "Squad: %d" % count

func update_score(score: int) -> void:
    if score_label:
        score_label.text = "Score: %d" % score

func update_level(level: int) -> void:
    if level_label:
        level_label.text = "Level: %d" % level

func update_progress(progress: float) -> void:
    if progress_bar:
        progress_bar.value = progress * 100.0

func _on_start_pressed() -> void:
    var game_manager := get_parent() as GameManager
    if game_manager:
        game_manager.start_new_game()

func _on_resume_pressed() -> void:
    var game_manager := get_parent() as GameManager
    if game_manager:
        game_manager.resume_game()

func _on_restart_pressed() -> void:
    var game_manager := get_parent() as GameManager
    if game_manager:
        game_manager.return_to_menu()
        await get_tree().process_frame
        game_manager.start_new_game()

func _on_menu_pressed() -> void:
    var game_manager := get_parent() as GameManager
    if game_manager:
        game_manager.return_to_menu()

func _on_continue_pressed() -> void:
    hide_level_complete_screen()
    # Game manager will handle level progression

func _on_play_again_pressed() -> void:
    var game_manager := get_parent() as GameManager
    if game_manager:
        game_manager.return_to_menu()
        await get_tree().process_frame
        game_manager.start_new_game()