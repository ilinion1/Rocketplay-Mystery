import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rocket_play/src/game/components/levels/level1.dart';
import 'package:rocket_play/src/game/components/levels/level3.dart';
import 'package:rocket_play/src/game/game.dart';

class ZnMiddleWidget extends StatelessWidget {
  const ZnMiddleWidget({
    super.key,
    required this.status,
    required this.type,
    required this.cardFlips,
    required this.isDone,
    required this.success,
    required this.level,
    required this.onTryAgainPressed,
    required this.onItemPressed,
  });

  final ZnGameStatus status;
  final List<int> type;
  final List<bool> cardFlips;
  final List<bool> isDone;
  final bool? success;
  final int level;
  final Function(int) onItemPressed;
  final Function() onTryAgainPressed;

  Widget playingWidget() {
    return switch (level) {
      1 => ZnLevel1(
          type: type,
          cardFlips: cardFlips,
          isDone: isDone,
          success: success,
          onItemPressed: (int itemIndex) async =>
              await onItemPressed(itemIndex),
        ),
      2 => ZnLevel1(
          type: type,
          cardFlips: cardFlips,
          isDone: isDone,
          success: success,
          onItemPressed: (int itemIndex) async =>
              await onItemPressed(itemIndex),
        ),
      3 => ZnLevel1(
          type: type,
          cardFlips: cardFlips,
          isDone: isDone,
          success: success,
          onItemPressed: (int itemIndex) async =>
              await onItemPressed(itemIndex),
        ),
      4 => ZnLevel1(
          type: type,
          cardFlips: cardFlips,
          isDone: isDone,
          success: success,
          onItemPressed: (int itemIndex) async =>
              await onItemPressed(itemIndex),
        ),
      5 => ZnLevel3(
          type: type,
          cardFlips: cardFlips,
          isDone: isDone,
          success: success,
          onItemPressed: (int itemIndex) async =>
              await onItemPressed(itemIndex),
        ),
      6 => ZnLevel3(
          type: type,
          cardFlips: cardFlips,
          isDone: isDone,
          success: success,
          onItemPressed: (int itemIndex) async =>
              await onItemPressed(itemIndex),
        ),
      _ => ZnLevel1(
          type: type,
          cardFlips: cardFlips,
          isDone: isDone,
          success: success,
          onItemPressed: (int itemIndex) async =>
              await onItemPressed(itemIndex),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      ZnGameStatus.playing => playingWidget(),
      ZnGameStatus.lose => Column(
          // mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Text(
                  'GAME OVER',
                  style: TextStyle(
                      fontFamily: 'Baloo 2',
                      fontSize: 56,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      height: 0.32),
                ),
                SizedBox(height: 26.h),
                const Text(
                  'Try your luck again!',
                  style: TextStyle(
                      fontFamily: 'Baloo 2',
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      height: 1.04),
                ),
              ],
            ),
          ],
        ),
      ZnGameStatus.won => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              'BIG WIN!',
              style: TextStyle(
                  fontFamily: 'Baloo 2',
                  fontSize: 56,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  height: 0.32),
            ),
            SizedBox(height: 26.h),
            const Text(
              'You managed to\ncollect all the pairs!',
              style: TextStyle(
                  fontFamily: 'Baloo 2',
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  height: 1.04),
            ),
            const SizedBox(height: 10),
          ],
        ),
    };
  }
}
