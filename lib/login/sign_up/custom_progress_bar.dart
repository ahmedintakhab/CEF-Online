import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const CustomProgressBar({
    required this.currentStep,
    required this.totalSteps,
    Key? key,
  })  : assert(currentStep > 0 && currentStep <= totalSteps),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 40.0,top: 20),
      // color: const Color(0xFFE6F0FA),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalSteps, (index) {
          final step = index + 1;
          final isCompleted = step < currentStep;
          final isCurrent = step == currentStep;

          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 30.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? Color(0xFF000080)
                        : isCurrent
                        ? Color(0xFF000080)
                        : Colors.grey,
                    border: Border.all(
                      color: isCompleted ? Color(0xFF000080) : Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  child: isCompleted
                      ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18.0,
                  )
                      : Center(
                    child: Text(
                      '$step',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (step < totalSteps)
                  Expanded(
                    child: Container(
                      height: 2.0,
                      color: step < currentStep
                          ? Color(0xFF000080)
                          : Colors.grey.withOpacity(0.3),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}