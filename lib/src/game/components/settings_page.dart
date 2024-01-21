import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rocket_play/src/common/app_images.dart';
import 'package:rocket_play/src/common/widgets/custom_button.dart';
import 'package:rocket_play/src/common/widgets/title_text.dart';
import 'package:rocket_play/src/controllers/settings_controller.dart';

class ZnSettingsPage extends StatelessWidget {
  const ZnSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = ZnSettingsProvider.watch(context).model;
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ZnAppImages.background1),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black45,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            children: [
              SizedBox(height: 68.h),
              const TitleText(title: 'SETTINGS'),
              SizedBox(height: 53.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sounds:',
                    style: TextStyle(
                        fontFamily: 'Baloo 2',
                        fontSize: 30.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.83),
                  ),
                  Switch(
                    trackOutlineWidth: const MaterialStatePropertyAll(1),
                    inactiveTrackColor: Colors.transparent,
                    inactiveThumbColor: Colors.white,
                    activeTrackColor: const Color(0xFFFFC700),
                    activeColor: const Color(0xFFFFF500),
                    trackOutlineColor: const MaterialStatePropertyAll(
                      Colors.white,
                    ),
                    value: model.sound,
                    onChanged: (value) async {
                      await model.setSound(value);
                    },
                  ),
                ],
              ),
              // SizedBox(height: 20.h),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 30.w),
              //   height: 107.h,
              //   width: double.infinity,
              //   decoration: decoration,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       ZnOutlinedText(
              //         text: 'Best Score: ${model.score}',
              //         textStyle: TextStyle(
              //           color: Colors.white,
              //           fontSize: 24.sp,
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              // SizedBox(height: 20.h),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 30.w),
              //   height: 107.h,
              //   width: double.infinity,
              //   decoration: decoration,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       ZnOutlinedText(
              //         text: 'Points: ${model.money}',
              //         textStyle: TextStyle(
              //           color: Colors.white,
              //           fontSize: 24.sp,
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              const Spacer(),
              ZnCustomButton(
                onPressed: () => Navigator.pop(context),
                text: 'Lobby',
              ),
              SizedBox(height: 64.h),
            ],
          ),
        ),
      ),
    );
  }
}
