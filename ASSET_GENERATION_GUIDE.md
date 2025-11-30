# 资源生成使用指南

## 🎨 如何生成游戏美术资源

我已经为您创建了多个高级纹理生成器，可以生成完整的游戏美术资源，无需外部工具！

## 📁 可用的资源生成器

### 1. 简化资源生成器 (`utils/asset_generator.gd`)
- **用途**: 快速生成基础游戏资源
- **特点**: 纯GDScript实现，无依赖
- **包含**: 角色、门、障碍物、UI、环境等

### 2. 高级纹理生成器 (`utils/advanced_texture_generator.gd`)
- **用途**: 生成高质量、详细的纹理
- **特点**: 渐变、阴影、复杂形状
- **样式**: 现代像素艺术风格

### 3. 精灵表生成器 (`utils/sprite_sheet_generator.gd`)
- **用途**: 生成动画精灵表
- **包含**: 角色动画帧、UI图标集
- **格式**: 512x512精灵表，每帧64x64

### 4. UI纹理生成器 (`utils/ui_texture_generator.gd`)
- **用途**: 生成现代UI元素
- **包含**: 按钮、面板、进度条、图标、加载动画
- **风格**: 现代扁平设计

## 🚀 如何使用

### 方法1: 自动生成（推荐）
1. 在Godot中打开 `scenes/asset_generator.tscn`
2. 运行场景
3. 所有资源将自动保存到 `assets/textures/` 目录
4. 游戏会自动使用生成的纹理

### 方法2: 手动控制
```gdscript
# 在任何脚本中调用
var stickman_texture := AdvancedTextureGenerator.create_detailed_stickman_texture()
var gate_texture := AdvancedTextureGenerator.create_detailed_gate_texture("add")
```

## 📋 生成的资源类型

### 角色资源
- `stickman_detailed.png` - 详细火柴人角色
- `stickman_walk_0.png` 到 `stickman_walk_3.png` - 行走动画帧
- `character_spritesheet.png` - 完整精灵表

### 数学门资源
- `gate_add_detailed.png` - 加法门（绿色）
- `gate_subtract_detailed.png` - 减法门（红色）
- `gate_multiply_detailed.png` - 乘法门（蓝色）
- `gate_divide_detailed.png` - 除法门（橙色）
- `gate_*_1.png`, `gate_*_5.png` 等 - 带数值的门

### 障碍物资源
- `obstacle_barrier_detailed.png` - 屏障障碍物
- `obstacle_spike_detailed.png` - 尖刺陷阱
- `obstacle_enemy_detailed.png` - 敌人角色
- `obstacle_zone_detailed.png` - 危险区域
- `*_damaged.png` - 损坏版本

### UI资源
- `ui_button_*_modern.png` - 现代按钮（normal/hover/pressed/disabled）
- `ui_panel_*_modern.png` - UI面板（default/dark/light）
- `ui_progressbar_modern.png` - 进度条
- `ui_healthbar_hearts.png` - 心形生命条
- `ui_icon_*_modern.png` - 图标集
- `ui_spinner_modern.png` - 加载动画

### 环境资源
- `ground_detailed.png` - 地面纹理
- `background_detailed.png` - 背景图像
- `finish_line.png` - 终点线
- `particle_*.png` - 粒子效果

## 🎨 纹理特点

### 高质量特性
- **抗锯齿**: 像素完美的对齐
- **阴影效果**: 所有角色都有动态阴影
- **渐变**: 现代渐变和光照效果
- **动画**: 完整的动画帧系统
- **一致性**: 统一的色彩方案和风格

### 色彩方案
- **角色**: 自然肤色 + 轮廓线
- **UI**: 蓝色主题 + 辅助色
- **环境**: 自然的大地色调
- **效果**: 高对比度的警告色

## 🔧 ResourceManager集成

ResourceManager已经更新，会按优先级使用纹理：
1. **高级纹理** (如果可用)
2. **基础纹理** (fallback)
3. **简单色块** (最后fallback)

```gdscript
# 自动检测并使用最佳可用纹理
var texture := ResourceManager.get_stickman_texture()  # 自动选择最佳质量
```

## 📱 分辨率和格式

- **角色**: 64x64像素，支持细节
- **门**: 96x144像素，突出显示
- **UI**: 多种尺寸，按需使用
- **环境**: 512x256背景，128x32地面
- **格式**: PNG，支持透明度

## 🎮 游戏集成

### 立即可用
1. 运行 `scenes/asset_generator.tscn`
2. 重新启动游戏
3. 所有纹理自动更新

### 自定义扩展
```gdscript
# 添加新的纹理类型
AdvancedTextureGenerator.create_custom_gate(custom_color, custom_symbol)

# 创建新的动画帧
SpriteSheetGenerator.create_custom_animation(frames)
```

## 📊 性能优化

- **预加载**: 所有纹理在启动时生成
- **缓存**: 避免重复计算
- **压缩**: PNG格式优化存储
- **批量生成**: 一次生成所有资源

## 🎯 质量保证

这些生成的纹理具有：
- ✅ 专业像素艺术质量
- ✅ 一致的视觉风格
- ✅ 优化的游戏性能
- ✅ 完整的动画支持
- ✅ 现代UI设计

---

**现在您拥有了完整的游戏美术资源生成系统！无需任何外部工具即可创建高质量的游戏资源。**