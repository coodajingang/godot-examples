# Godot Game Development Best Practices Spec

This spec defines the best practices that **cto new** must follow when assisting in Godot 4 game development.

---

## 1. Project Structure
- Use a clean, modular folder structure:
  ```
  /scenes
  /scripts
  /assets
      /textures
      /audio
      /fonts
  /ui
  /utils
  ```
- Each scene should contain only the nodes it needs.
- Avoid giant monolithic scenes; prefer composition over inheritance.

---

## 2. Scene & Node Guidelines
- Follow **Godot's node philosophy**: each node has a clear purpose.
- Use **instancing** instead of duplicating logic.
- Keep UI scenes separate from gameplay scenes.
- Use `autoload` (singleton) only for global state (player data, game settings, event bus).

---

## 3. GDScript Best Practices
- Prefer **GDScript** unless performance-critical (then use C# or GDNative).
- Class structure template:
  ```gdscript
  extends Node
  
  @onready var player = get_node("../Player")

  func _ready() -> void:
      pass

  func _process(delta: float) -> void:
      pass
  ```
- Always type annotate variables and function returns.
- Use signals instead of tight coupling.
- Avoid using deeply nested `get_node` paths; use exported vars or dependency injection.

---

## 4. Signals & Events
- Prefer **signals** for communication between entities.
- Use an event bus autoload if many systems communicate.
- Never directly reference nodes across distant systems.
- Example:
  ```gdscript
  signal health_changed(new_value: int)
  ```

---

## 5. Performance Guidelines
- Use object pooling for frequently created/destroyed objects (bullets, particles).
- Avoid heavy logic inside `_process`, prefer timers, signals, and state machines.
- Use Godot's built‑in debugging tools (Profiler, Monitor, Frame Time Graph).
- Preload resources instead of load() during gameplay.
- Avoid large physics tick rates unless required.

---

## 6. Asset Management
- Use compressed textures (WebP/PNG) based on target platform.
- Keep audio normalized and compressed.
- Use `import presets` for consistent resource settings.
- Avoid huge atlas textures; split into logical groups.

---

## 7. UI & UX Practices
- Use Containers instead of manual positioning.
- Use dynamic layout for different resolutions.
- Keep UI logic and gameplay logic strictly separated.
- Avoid hard-coded colors, fonts; define a global theme.

---

## 8. Input System
- Use Godot's **InputMap**.
- Do not manually check keycodes.
- All gameplay input should be abstracted:
  ```gdscript
  if Input.is_action_just_pressed("jump"):
      jump()
  ```

---

## 9. State Machine Pattern
- Use clear state-based logic for complex behaviors.
- Use `enum` or separate scripts.
- Keep transitions clean and explicit.

---

## 10. Testing & Debugging
- Add debug commands via a debug overlay.
- Use `print_debug` or custom logger.
- Use fake/mock objects for testing isolated systems.

---

## 11. Build & Export
- Create export presets early.
- Validate mobile UI scaling.
- Add versioning script to auto-increment builds.

---

## 12. Documentation Requirements
- Each major system requires a README.md.
- Public methods must include short docstrings.
- Provide diagrams (state machine, scene hierarchy) when useful.

---

## 13. cto new Instructions
When generating code or tasks:
- Follow this spec strictly.
- Use best practices above when proposing scenes, scripts, or architecture.
- When multiple solutions exist, choose the one that is maintainable and modular.
- Automatically suggest refactoring when user writes anti-patterns.

---

**End of Spec**

