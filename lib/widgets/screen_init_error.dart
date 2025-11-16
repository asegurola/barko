import 'package:flutter/material.dart';

class ScreenInitError extends StatelessWidget {
  final String? customErrorMessage;
  final VoidCallback onTryAgain;
  final bool allowRetry;
  final VoidCallback onExitApp;

  const ScreenInitError({
    super.key,
    this.customErrorMessage,
    required this.allowRetry,
    required this.onTryAgain,
    required this.onExitApp,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            customErrorMessage ?? 'Oops! We spilled our coffee.',
            textAlign: TextAlign.center,
          ),
          const SizedBox.square(dimension: 8.0),
          if (allowRetry)
            ElevatedButton(
              onPressed: onTryAgain,
              child: const Text('Try again'),
            )
          else
            Column(
              children: [
                const Text(
                  'Try again later',
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  onPressed: onExitApp,
                  child: const Text('Exit app'),
                ),
              ],
            )
        ],
      ),
    );
  }
}
