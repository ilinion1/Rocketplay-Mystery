import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rocket_play/src/common/app_images.dart';
import 'package:rocket_play/src/common/widgets/custom_button.dart';
import 'package:rocket_play/src/common/widgets/custom_icon_button.dart';
import 'package:rocket_play/src/controllers/settings_controller.dart';
import 'package:rocket_play/src/game/components/level_page.dart';
import 'package:rocket_play/src/game/components/rules_page.dart';
import 'package:rocket_play/src/game/components/settings_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = ZnSettingsProvider.watch(context).model;
    final difference = model.dateTime.difference(DateTime.now());
    final myDuration = (const Duration(days: 1) + difference);
    final formattedDuration =
        "${myDuration.inHours}:${(myDuration.inMinutes % 60).toString().padLeft(2, '0')}:${(myDuration.inSeconds % 60).toString().padLeft(2, '0')}";

    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ZnAppImages.mainBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ZnCustomIconButton(
                    icon: ZnAppImages.settings,
                    onPressed: () {
                      return Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ZnSettingsProvider(
                            model: model,
                            child: const ZnSettingsPage(),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 22),
                ],
              ),
              const SizedBox(height: 165),
              ZnCustomButton(
                onPressed: () {
                  if (difference.inDays >= -1) return;
                  showDialog(
                    context: context,
                    builder: (context) => DailyLoginWidget(
                      child: ContentWidget(
                        model: model,
                      ),
                    ),
                  );
                },
                text: (difference.inDays >= -1)
                    ? 'Next Daily Reward in $formattedDuration'
                    : 'Daily Reward',
                buttonType: 'daily',
              ),
              const SizedBox(height: 25),
              ZnCustomButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ZnSettingsProvider(
                      model: model,
                      child: const ZnLevelMap(),
                    ),
                  ),
                ),
                text: 'Play',
              ),
              const SizedBox(height: 25),
              ZnCustomButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ZnRulesPage(),
                  ),
                ),
                text: 'Rules',
              ),
              const SizedBox(height: 108),
            ],
          ),
        ),
      ),
    );
  }
}

class DailyLoginWidget extends StatelessWidget {
  const DailyLoginWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(top: 170.h),
        child: SizedBox(
          width: 344.w,
          height: 290.h,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Image.asset(
                ZnAppImages.dailyLoginDialog,
                fit: BoxFit.contain,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(ZnAppImages.buttonScore,
                        fit: BoxFit.contain, width: 282.w, height: 44.h),
                    Text(
                      'Daily Reward',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Baloo 2',
                          fontSize: 18.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 270,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    'assets/images/ok.png',
                    width: 162,
                    height: 56,
                  ),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class ContentWidget extends StatelessWidget {
  const ContentWidget({
    super.key,
    required this.model,
  });

  final ZnSettingsController model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 90.h,
      ),
      child: Column(
        children: [
          SizedBox(height: 5.h),
          const Text(
            'Open the box and find out what\nyou won!',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Baloo 2',
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                height: 1.33),
          ),
          GestureDetector(
            onTap: () async {
              await model.setDateTime();
              final rand = Random();
              final number = rand.nextInt(3);
              if (!context.mounted) return;
              Navigator.pop(context);
              if (number == 0) {
                print('lose');
                showDialog(
                  context: context,
                  builder: (context) => const DailyLoginWidget(
                    child: WinOrLoseWidget(
                      text: 'Try again in next time',
                      image: ZnAppImages.dailyMoney,
                    ),
                  ),
                );
                return;
              }
              showDialog(
                context: context,
                builder: (context) => const DailyLoginWidget(
                  child: WinOrLoseWidget(
                    text: ' +20 points',
                    image: ZnAppImages.dailyMoney,
                  ),
                ),
              );
              await model.setMoney(20);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Image.asset(
                    ZnAppImages.box,
                    width: 88.w,
                    height: 100.h,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WinOrLoseWidget extends StatelessWidget {
  const WinOrLoseWidget({
    super.key,
    required this.text,
    required this.image,
  });

  final String text;
  final String image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(top: 100.h),
        child: Column(
          children: [
            Text(
              text,
              style: const TextStyle(
                  fontFamily: 'Baloo 2',
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  height: 0.6),
            ),
            SizedBox(height: 10.h),
            Image.asset(
              image,
              width: 168.w,
              height: 120.h,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
