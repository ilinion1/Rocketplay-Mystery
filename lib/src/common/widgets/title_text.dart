import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleText extends StatelessWidget {
  final String title;
  const TitleText({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          backgroundColor: Color(0XFFFFDE00),
          radius: 5,
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Baloo 2',
              fontSize: 36.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 3.6),
        ),
        SizedBox(width: 10.w),
        const CircleAvatar(
          backgroundColor: Color(0XFFFFDE00),
          radius: 5,
        ),
      ],
    );
  }
}
