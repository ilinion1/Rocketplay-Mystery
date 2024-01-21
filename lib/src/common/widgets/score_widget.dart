import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rocket_play/src/common/app_images.dart';

class ScoreWidget extends StatelessWidget {
  const ScoreWidget({
    super.key,
    required this.score,
    this.isClosed = false,
  });

  final int score;
  final bool isClosed;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(ZnAppImages.buttonScore,
            fit: BoxFit.contain, width: 282.w, height: 44.h),
        Text(
          'Best Score: $score',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Baloo 2',
              fontSize: 18.sp,
              color: Colors.black,
              fontWeight: FontWeight.w800,
              letterSpacing: 1),
        ),
      ],
    );
  }
}
