# Godot examples

## Math Runner: Stickman Squad

A Godot 4 implementation of a Count Control Legends-inspired game combining mathematics, runner gameplay, and squad management.

### 🚨 Current Status
**基础功能已完成，但需要手工配置才能正常运行**

### Quick Start
1. Open the project in Godot 4.x
2. Run the main scene (`scenes/main.tscn`)
3. Use A/D keys to move your stickman squad through math gates
4. Avoid obstacles and choose the right operations to maximize your squad count!

### 🔧 Required Manual Setup
**重要**: 在运行游戏前，请参考 `SETUP_GUIDE.md` 文件进行配置：

1. **场景文件修复**: 所有动画路径已修复，场景现在可以正常打开
2. **资源管理**: 添加了fallback纹理系统，即使没有美术资源也能运行
3. **空引用处理**: 所有@onready变量使用get_node_or_null()防止错误

### Features
- **Math-based gameplay**: Addition, subtraction, multiplication, and division gates
- **Squad management**: Control and formation of stickman units
- **Procedural levels**: 5 levels with increasing difficulty
- **Risk-reward decisions**: Balance safe operations vs high-risk multipliers
- **Clean architecture**: Following Godot 4 best practices with modular design
- **Robust error handling**: Fallback systems for missing assets and nodes

### 🎮 Controls
- **A/Left Arrow**: Move squad left
- **D/Right Arrow**: Move squad right  
- **Space/Up Arrow**: Jump (when implemented)
- **ESC**: Pause/Resume game

### 📋 Development Checklist
- [x] Core game mechanics
- [x] Scene structure and organization
- [x] Event system and communication
- [x] UI system and state management
- [x] Math gate logic
- [x] Obstacle system
- [x] Squad formation system
- [x] Procedural level generation
- [x] Error handling and fallbacks
- [ ] High-quality art assets
- [ ] Sound effects and music
- [ ] Additional polish and effects

See the full README.md for detailed documentation and technical implementation.
