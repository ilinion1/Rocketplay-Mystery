import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rocket_play/src/common/app_colors.dart';
import 'package:rocket_play/src/common/app_images.dart';
import 'package:rocket_play/src/common/widgets/custom_button.dart';
import 'package:rocket_play/src/common/widgets/title_text.dart';
import 'package:rocket_play/src/game/components/card_widget.dart';

class ZnRulesPage extends StatelessWidget {
  const ZnRulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ZnAppImages.background1),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // const SizedBox.shrink(),
            SizedBox(
              height: 80.h,
            ),
            const TitleText(title: 'RULES'),
            SizedBox(height: 40.h),
            const Text(
              'You have to collect pairs of\n elements hidden under the cards',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Baloo 2',
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  height: 1.13),
            ),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ZnCardWidget(
                  value: 13,
                  isFlipped: true,
                  onPressed: () {},
                  color: ZnAppColors.mainColor,
                  isDone: false,
                ),
                const SizedBox(width: 8),
                ZnCardWidget(
                  value: 13,
                  isFlipped: true,
                  onPressed: () {},
                  color: ZnAppColors.mainColor,
                  isDone: false,
                ),
              ],
            ),
            SizedBox(height: 65.h),
            const Text(
              'You earn points for every\nsuccessful combination',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Baloo 2',
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  height: 1.13),
            ),
            SizedBox(
              height: 10.h,
            ),
            const Text(
              'Score: 50',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Baloo 2',
                  fontSize: 42.5,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  height: 1),
            ),
            SizedBox(height: 65.h),

            const Text(
              'If you fail, you lose your extra\nhearts. Their offering is limited.\nWhen they run out, the game is over',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Baloo 2',
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  height: 1.13),
            ),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  ZnAppImages.diamond,
                  width: 46,
                  height: 40,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 3),
                Image.asset(
                  ZnAppImages.diamond,
                  width: 46,
                  height: 40,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 3),
                Image.asset(
                  ZnAppImages.diamond,
                  width: 46,
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            const Spacer(),
            ZnCustomButton(
              onPressed: () => Navigator.pop(context),
              text: 'Lobby',
            ),
            SizedBox(height: 57.h),
          ],
        ),
      ),
    );
  }
}
