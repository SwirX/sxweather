import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';

class SunCycleProgress extends StatefulWidget {
  const SunCycleProgress(
      {super.key, required this.sunrise, required this.sunset});

  final DateTime sunrise;
  final DateTime sunset;

  @override
  State<SunCycleProgress> createState() => _SunCycleProgressState();
}

class _SunCycleProgressState extends State<SunCycleProgress> {
  Timer? timer;
  double timeProgress = 0;
  bool isNight = false;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        final current = DateTime.now();
        var value = current.millisecondsSinceEpoch /
            widget.sunset.millisecondsSinceEpoch;
        var night = true;
        if (value >= 1) {
          print("it past sunset");
          print("calculating time till sunrise");
          value = current.millisecondsSinceEpoch /
              widget.sunrise.millisecondsSinceEpoch;
        } else {
          print("it past sunrise");
          print("calculating time till sunset");
          night = false;
        }
        print("time progress: $timeProgress");
        print("is night? $isNight");
        setState(() {
          isNight = night;
          timeProgress = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProgressBar(
      value: timeProgress,
      gradient: isNight
          ? const LinearGradient(
              colors: [
                Color.fromARGB(255, 22, 37, 80),
                Color(0xffaa9950),
              ],
            )
          : const LinearGradient(
              colors: [
                Color(0xffaa9950),
                Color.fromARGB(255, 22, 37, 80),
              ],
            ),
    );
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }
}
