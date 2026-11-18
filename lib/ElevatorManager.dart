import 'dart:async';

import 'package:flutter/material.dart';

import 'AudioManager.dart';

enum ElevatorDirection { up, down, idle }

class ElevatorManager extends ChangeNotifier {
  int _currentFloor = 0;
  ElevatorDirection _direction = ElevatorDirection.idle;
  final Set<int> _selectedFloors = {};
  bool _isStopped = false;
  Timer? _timer;
  final _audioManager = AudioManager.instance;
  bool _isDoorOpen = false;

  bool get isDoorOpen => _isDoorOpen;

  int get currentFloor => _currentFloor;

  ElevatorDirection get direction => _direction;

  bool get isStopped => _isStopped;

  Set<int> get selectedFloors => _selectedFloors;

  ElevatorManager() {
    _audioManager.init();
  }

  void onFloorPressed(int floor) {
    if (floor == _currentFloor && _direction == ElevatorDirection.idle) return;
    _isStopped = false;
    _selectedFloors.add(floor);
    notifyListeners();
    _moveElevator();
  }

  void onStopPressed() {
    _audioManager.stopMovingSound();
    _timer?.cancel();
    _selectedFloors.clear();
    _isStopped = true;
    _isDoorOpen = false;
    _direction = ElevatorDirection.idle;
    notifyListeners();
  }

  void _moveElevator() {
    if (_timer != null && _timer!.isActive) return;
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_isDoorOpen) {
        _direction = ElevatorDirection.idle;
        _isDoorOpen = false;
        if (_selectedFloors.isEmpty) {
          _audioManager.stopMovingSound();
          _direction = ElevatorDirection.idle;
          timer.cancel();
        }
        notifyListeners();
        return;
      }

      if (_selectedFloors.isEmpty) {
        _audioManager.stopMovingSound();
        _direction = ElevatorDirection.idle;
        timer.cancel();
        notifyListeners();
        return;
      }

      _audioManager.startMovingSound();

      if (_direction == ElevatorDirection.idle) {
        _direction = _selectedFloors.first > _currentFloor
            ? ElevatorDirection.up
            : ElevatorDirection.down;
      } else if (_direction == ElevatorDirection.up &&
          !_selectedFloors.any((f) => f > _currentFloor)) {
        _direction = ElevatorDirection.down;
      } else if (_direction == ElevatorDirection.down &&
          !_selectedFloors.any((f) => f < _currentFloor)) {
        _direction = ElevatorDirection.up;
      }
      if (_direction == ElevatorDirection.up) {
        _currentFloor++;
      } else if (_direction == ElevatorDirection.down) {
        _currentFloor--;
      }

      if (_selectedFloors.contains(_currentFloor)) {
        _selectedFloors.remove(_currentFloor);
        _audioManager.stopMovingSound();
        _isDoorOpen = true;
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioManager.dispose();
    super.dispose();
  }
}
