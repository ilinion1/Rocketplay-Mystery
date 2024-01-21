import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rocket_play/src/common/app_images.dart';

class LevelAppBar extends StatelessWidget {
  const LevelAppBar({
    super.key,
    required this.level,
  });

  final int level;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(ZnAppImages.levelAppBar,
            fit: BoxFit.contain, width: 122.w, height: 44.h),
        Text(
          'Level: $level',
          style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              height: 1),
        ),
      ],
    );
  }
}
