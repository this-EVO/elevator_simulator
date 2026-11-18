# Elevator Simulator (Flutter)

A simple, interactive elevator control panel simulation built with Flutter. It mimics real-world elevator behavior including multi-floor request queuing, directional scheduling, door-open pauses, emergency stop, and continuous movement audio.



https://github.com/user-attachments/assets/21d44251-3007-443e-a033-d84f72006d2c


## Features

- **Digital LED Display:** Shows the current floor number, active direction indicators (Up/Down arrows), and `Stopped` status.
- **Multi-Floor Request Queuing:** Select multiple floors (`0` to `7`); active requests glow until reached.
- **Smart Directional Logic:** Completes all queued requests in the current travel direction before reversing (SCAN-style scheduling).
- **Realistic Door Pause:** Pauses at each requested floor before continuing to the next destination.
- **Emergency Stop:** Immediately halts movement, clears pending floor requests, and stops audio playback.
- **Audio Feedback:** Loops elevator movement sound while in motion using `audioplayers`.

## Project Structure

```text
lib/
├── main.dart                  # App entry point
├── ElevatorPanelScreen.dart   # UI components & ListenableBuilder binding
├── ElevatorManager.dart       # State management (ChangeNotifier), timer, and movement logic
└── AudioManager.dart          # Singleton audio handler for movement sound effects
assets/
└── sounds/
    └── elevator_sound.m4a     # Continuous movement audio file


