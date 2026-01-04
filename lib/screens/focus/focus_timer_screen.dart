import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/haptic_utils.dart';
import '../../providers/focus_provider.dart';

class FocusTimerScreen extends StatefulWidget {
  const FocusTimerScreen({super.key});

  @override
  State<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends State<FocusTimerScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Timer'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<FocusProvider>(
          builder: (context, provider, _) {
            return Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTimer(provider),
                        const SizedBox(height: 40),
                        _buildStateLabel(provider),
                        const SizedBox(height: 16),
                        _buildSessionCounter(provider),
                        const SizedBox(height: 40),
                        _buildControls(provider),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirection: pi / 2,
                    emissionFrequency: 0.05,
                    numberOfParticles: 20,
                    gravity: 0.1,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimer(FocusProvider provider) {
    final minutes = provider.remainingSeconds ~/ 60;
    final seconds = provider.remainingSeconds % 60;
    final progress = _calculateProgress(provider);

    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 280,
            height: 280,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 12,
              backgroundColor: AppColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getTimerColor(provider.state),
              ),
            ),
          )
              .animate(
                onPlay: (controller) =>
                    provider.state == FocusTimerState.work ? controller.repeat() : null,
              )
              .shimmer(duration: 2.seconds, color: Colors.white24),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStateLabel(FocusProvider provider) {
    String label;
    switch (provider.state) {
      case FocusTimerState.idle:
        label = 'Ready to Focus';
        break;
      case FocusTimerState.work:
        label = 'Focus Time';
        break;
      case FocusTimerState.shortBreak:
        label = 'Short Break';
        break;
      case FocusTimerState.longBreak:
        label = 'Long Break - Well Done!';
        break;
      case FocusTimerState.paused:
        label = 'Paused';
        break;
    }

    return Text(
      label,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.textSecondary,
          ),
    );
  }

  Widget _buildSessionCounter(FocusProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isCompleted = index < provider.sessionCount % 4;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? AppColors.primary : AppColors.surfaceVariant,
          ),
        );
      }),
    );
  }

  Widget _buildControls(FocusProvider provider) {
    if (provider.state == FocusTimerState.idle) {
      return _buildStartButton(provider);
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (provider.state == FocusTimerState.work) _buildPauseButton(provider),
          if (provider.state == FocusTimerState.paused) _buildResumeButton(provider),
          const SizedBox(width: 16),
          _buildResetButton(provider),
        ],
      );
    }
  }

  Widget _buildStartButton(FocusProvider provider) {
    return ElevatedButton.icon(
      onPressed: () {
        HapticUtils.mediumImpact();
        provider.startWorkSession();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      icon: const Icon(Icons.play_arrow, size: 28),
      label: const Text('Start Focus', style: TextStyle(fontSize: 18)),
    );
  }

  Widget _buildPauseButton(FocusProvider provider) {
    return ElevatedButton.icon(
      onPressed: () {
        HapticUtils.lightImpact();
        provider.pause();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.warning,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      icon: const Icon(Icons.pause),
      label: const Text('Pause'),
    );
  }

  Widget _buildResumeButton(FocusProvider provider) {
    return ElevatedButton.icon(
      onPressed: () {
        HapticUtils.lightImpact();
        provider.resume();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.success,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      icon: const Icon(Icons.play_arrow),
      label: const Text('Resume'),
    );
  }

  Widget _buildResetButton(FocusProvider provider) {
    return OutlinedButton.icon(
      onPressed: () {
        HapticUtils.lightImpact();
        provider.reset();
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      icon: const Icon(Icons.refresh),
      label: const Text('Reset'),
    );
  }

  double _calculateProgress(FocusProvider provider) {
    int totalSeconds;
    switch (provider.state) {
      case FocusTimerState.work:
        totalSeconds = 25 * 60;
        break;
      case FocusTimerState.shortBreak:
        totalSeconds = 5 * 60;
        break;
      case FocusTimerState.longBreak:
        totalSeconds = 15 * 60;
        break;
      default:
        totalSeconds = 25 * 60;
    }
    return 1 - (provider.remainingSeconds / totalSeconds);
  }

  Color _getTimerColor(FocusTimerState state) {
    switch (state) {
      case FocusTimerState.work:
        return AppColors.primary;
      case FocusTimerState.shortBreak:
        return AppColors.success;
      case FocusTimerState.longBreak:
        return AppColors.secondary;
      default:
        return AppColors.primary;
    }
  }
}
