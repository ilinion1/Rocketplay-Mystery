import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rocket_play/src/common/app_images.dart';
import 'package:rocket_play/src/common/widgets/custom_button.dart';
import 'package:rocket_play/src/common/widgets/score_widget.dart';
import 'package:rocket_play/src/controllers/settings_controller.dart';
import 'package:rocket_play/src/game/components/level_page.dart';
import 'package:rocket_play/src/game/components/main_page.dart';
import 'package:rocket_play/src/game/components/rules_page.dart';
import 'package:rocket_play/src/game/components/settings_page.dart';

void main() {
  runApp(const ZnMyApp());
}

class ZnMyApp extends StatelessWidget {
  const ZnMyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenUtilInit(
      designSize: Size(393, 852),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ZnProgressPage(),
      ),
    );
  }
}

class ZnProgressPage extends StatefulWidget {
  const ZnProgressPage({super.key});

  @override
  State createState() => _MyAnimatedProgressBarState();
}

class _MyAnimatedProgressBarState extends State<ZnProgressPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  late ZnSettingsController model;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addStatusListener(_splsg);
    _progressAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_progressController);
    _progressController.forward();
    model = ZnSettingsController();
  }

  void _splsg(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ZnSettingsProvider(
            model: model,
            child: ZnInitAudio(
              child: FutureBuilder(
                future: model.initSettings(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return const ZnPageTest();
                  } else if (snapshot.hasError) {
                    return const Text('Error');
                  } else {
                    return const ZnFastSplashScreen();
                  }
                },
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ZnAppImages.mainBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 80.h),
              child: AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.r),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(5.w),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFC5AC00),
                              Color(0xFFFFEA55),
                            ],
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.r),
                          child: SizedBox(
                            width: double.infinity,
                            height: 30.h,
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.green.shade100,
                              color: Color.lerp(
                                const Color(0xFFC5AC00),
                                const Color(0xFFFFEA55),
                                _progressAnimation.value,
                              ),
                              value: _progressAnimation.value,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _progressController.removeStatusListener(_splsg);
    _progressController.dispose();
    super.dispose();
  }
}

class ZnPageTest extends StatefulWidget {
  const ZnPageTest({super.key});

  @override
  State<ZnPageTest> createState() => _ZnPageTestState();
}

class _ZnPageTestState extends State<ZnPageTest> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final model = ZnSettingsProvider.watch(context).model;
      final difference = model.dateTime.difference(DateTime.now());
      print(model.dateTime);
      print(difference);
      if (difference.inDays < -1) {
        showDialog(
          context: context,
          builder: (context) => DailyLoginWidget(
            child: ContentWidget(
              model: model,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = ZnSettingsProvider.watch(context).model;

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
              ScoreWidget(score: model.score),
              SizedBox(height: 103.h),
              ZnCustomButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ZnSettingsProvider(
                      model: model,
                      // child: MyGame(level: model.level),
                      child: const ZnLevelMap(),
                    ),
                  ),
                ),
                text: 'New Game',
              ),
              SizedBox(height: 20.h),
              ZnCustomButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ZnRulesPage(),
                  ),
                ),
                text: 'Rules',
              ),
              SizedBox(height: 20.h),
              ZnCustomButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ZnSettingsProvider(
                      model: model,
                      child: const ZnSettingsPage(),
                    ),
                  ),
                ),
                text: 'Settings',
              ),
              SizedBox(height: 57.h),
            ],
          ),
        ),
      ),
    );
  }
}

class ZnInitAudio extends StatefulWidget {
  const ZnInitAudio({super.key, required this.child});

  final Widget child;

  @override
  State createState() => ZnInitAudioState();
}

class ZnInitAudioState extends State<ZnInitAudio> with WidgetsBindingObserver {
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (AppLifecycleState.paused == state) {
      final model = ZnSettingsProvider.read(context)!.model;
      await model.stopAudio();
    } else if (AppLifecycleState.resumed == state) {
      if (ZnSettingsProvider.read(context)!.model.sound) {
        final model = ZnSettingsProvider.read(context)!.model;
        if (model.sound) {
          await model.playAudio();
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (value) async {
        final model = ZnSettingsProvider.read(context)!.model;
        await model.stopAudio();
      },
      child: widget.child,
    );
  }
}

class ZnFastSplashScreen extends StatelessWidget {
  const ZnFastSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ZnAppImages.background1),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
