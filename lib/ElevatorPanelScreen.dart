import 'package:elevator_sim/ElevatorManager.dart';
import 'package:flutter/material.dart';

class ElevatorPanelScreen extends StatefulWidget {
  const ElevatorPanelScreen({super.key});

  @override
  State<ElevatorPanelScreen> createState() => _ElevatorPanelScreenState();
}

class _ElevatorPanelScreenState extends State<ElevatorPanelScreen> {
  final _elevatorManager = ElevatorManager();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _elevatorManager,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          backgroundColor: const Color(0xff40f37e),
          body: Center(
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF2B2D35),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade800, width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDigitalDisplay(),
                  const SizedBox(height: 30),

                  _buildFloorButtonsGrid(),
                  const SizedBox(height: 24),

                  _buildStopButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDigitalDisplay() {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0C0E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade700, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _elevatorManager.isStopped
                ? 'Stopped'
                : _elevatorManager.isDoorOpen
                ? 'Door is opened'
                : '${_elevatorManager.currentFloor}',
            style: TextStyle(
              fontSize: _elevatorManager.isDoorOpen ? 16 : 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              color: _elevatorManager.isStopped || _elevatorManager.isDoorOpen
                  ? Colors.redAccent
                  : const Color(0xFF00FF66),
              shadows: [
                Shadow(
                  color:
                      (_elevatorManager.isStopped || _elevatorManager.isDoorOpen
                              ? Colors.redAccent
                              : const Color(0xFF00FF66))
                          .withValues(alpha: 0.6),
                  blurRadius: 15,
                ),
              ],
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.keyboard_arrow_up_rounded,
                size: 40,
                color:
                    _elevatorManager.direction == ElevatorDirection.up &&
                        !_elevatorManager.isStopped
                    ? const Color(0xFF00FF66)
                    : Colors.grey.shade900,
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 40,
                color:
                    _elevatorManager.direction == ElevatorDirection.down &&
                        !_elevatorManager.isStopped
                    ? const Color(0xFF00FF66)
                    : Colors.grey.shade900,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloorButtonsGrid() {
    final floors = [7, 6, 5, 4, 3, 2, 1, 0];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: floors.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 20,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        final floor = floors[index];
        final isSelected = _elevatorManager.selectedFloors.contains(floor);

        return GestureDetector(
          onTap: () => _elevatorManager.onFloorPressed(floor),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1F2026),
              border: Border.all(
                color: isSelected ? Colors.redAccent : Colors.grey.shade600,
                width: isSelected ? 3 : 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.redAccent.withValues(alpha: 0.5),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                '$floor',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.redAccent : Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStopButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: () => _elevatorManager.onStopPressed(),
        style: ElevatedButton.styleFrom(
          backgroundColor: _elevatorManager.isStopped
              ? Colors.red.shade900
              : Colors.red.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: _elevatorManager.isStopped
                  ? Colors.redAccent
                  : Colors.transparent,
              width: 2,
            ),
          ),
          elevation: 6,
        ),
        child: const Text(
          'STOP',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _elevatorManager.dispose();
    super.dispose();
  }
}
