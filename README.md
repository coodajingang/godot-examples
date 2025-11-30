# Math Runner: Stickman Squad

A Godot 4 game inspired by Count Control Legends, combining mathematics, runner gameplay, and squad management.

## Game Overview

Control a stickman squad through mathematical gates while avoiding obstacles. Your squad count is your main resource - choose the right math operations to maximize your numbers and reach the finish line with as many squad members as possible!

## Core Mechanics

### Resource Management
- **Squad Count**: Your primary resource representing strength, survival, and score potential
- **Math Gates**: Choose between addition (+), subtraction (-), multiplication (×), and division (÷) operations
- **Risk vs Reward**: Balance safe operations (addition) with high-risk, high-reward choices (multiplication)

### Gameplay Elements
- **Movement**: Use A/D or arrow keys to move left/right
- **Obstacles**: Avoid barriers, enemies, spikes, and traps that reduce squad count
- **Level Progression**: 5 levels with increasing difficulty and complexity
- **Victory Condition**: Complete all levels with maximum squad members for the highest score

## Controls

- **A/Left Arrow**: Move squad left
- **D/Right Arrow**: Move squad right  
- **Space/Up Arrow**: Jump (when implemented)
- **ESC**: Pause/Resume game

## Technical Implementation

### Architecture
- **Event Bus**: Global communication system for decoupled components
- **Resource Manager**: Centralized asset loading and caching
- **Level Manager**: Procedural level generation with configurable difficulty
- **UI Manager**: Separated UI logic following Godot best practices

### Scene Structure
```
/scenes
  ├── main.tscn          # Main game scene
  ├── stickman.tscn      # Individual squad member
  ├── math_gate.tscn     # Mathematical operation gates
  └── obstacle.tscn      # Obstacles and hazards

/scripts
  ├── game_manager.gd    # Main game controller
  ├── level_manager.gd   # Level generation and flow
  ├── stickman_squad.gd  # Squad management and formation
  ├── stickman.gd        # Individual stickman behavior
  ├── math_gate.gd       # Gate logic and operations
  ├── obstacle.gd        # Obstacle behavior and damage
  ├── ui_manager.gd      # UI state management
  └── event_bus.gd       # Global event system

/utils
  ├── resource_manager.gd    # Asset loading
  └── texture_generator.gd   # Procedural texture creation
```

### Key Features
- **Modular Design**: Each system is self-contained and communicates via signals
- **Type Safety**: All GDScript uses strict typing
- **Performance**: Object pooling for squad members, preloaded resources
- **Extensibility**: Easy to add new gate types, obstacles, and level mechanics

## Development Notes

This game follows the Godot 4 best practices outlined in `specs/godot_best_practices.md`:
- Modular folder structure
- Signal-driven communication
- InputMap-based controls
- Separation of UI and gameplay logic
- Typed GDScript patterns

## Future Enhancements

Potential features for future iterations:
- Boss battles with squad-based combat
- Power-ups and special abilities
- Multiple squad formations with tactical advantages
- Online leaderboards and score sharing
- Additional mathematical operations (powers, roots, modulo)
- Environmental hazards and weather effects
- Squad member customization and upgrades