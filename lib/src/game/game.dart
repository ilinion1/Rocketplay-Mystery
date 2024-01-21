import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rocket_play/src/common/app_images.dart';
import 'package:rocket_play/src/common/widgets/custom_button.dart';
import 'package:rocket_play/src/common/widgets/level_app_bar.dart';
import 'package:rocket_play/src/controllers/settings_controller.dart';
import 'package:rocket_play/src/game/components/middle_widget.dart';

enum ZnGameStatus { won, lose, playing }

class ZnMyGame extends StatefulWidget {
  const ZnMyGame({
    super.key,
    required this.level,
  });

  final int level;

  @override
  State<ZnMyGame> createState() => _ZnMyGameState();
}

class _ZnMyGameState extends State<ZnMyGame> {
  bool win = false;
  late int level;
  double textOpacity = 1;
  // comment
  String title = 'Click on the card to start';

  // for check
  int selectedIndex = -1;
  bool? success;
  bool isPause = false;

  // score & lifes
  int life = 3;
  int score = 0;

  // status
  ZnGameStatus status = ZnGameStatus.playing;

  late List<int> type;
  void levelType() {
    type = switch (level) {
      1 => List.generate(4, (index) => index + 1),
      2 => List.generate(6, (index) => index + 1),
      3 => List.generate(8, (index) => index + 1),
      4 => List.generate(10, (index) => index + 1),
      5 => List.generate(13, (index) => index + 1),
      6 => List.generate(13, (index) => index + 1),
      _ => List.generate(4, (index) => index + 1),
    };
  }

  // Card flipped or not
  late List<bool> cardFlips;
  void levelCardFlips() {
    cardFlips = switch (level) {
      1 => List.generate(8, (index) => false),
      2 => List.generate(12, (index) => false),
      3 => List.generate(16, (index) => false),
      4 => List.generate(20, (index) => false),
      5 => List.generate(30, (index) => false),
      6 => List.generate(36, (index) => false),
      _ => List.generate(8, (index) => false),
    };
  }

  // Card flipped & is done
  late List<bool> isDone;
  void levelIsDone() {
    isDone = switch (level) {
      1 => List.generate(8, (index) => false),
      2 => List.generate(12, (index) => false),
      3 => List.generate(16, (index) => false),
      4 => List.generate(20, (index) => false),
      5 => List.generate(30, (index) => false),
      6 => List.generate(36, (index) => false),
      _ => List.generate(8, (index) => false),
    };
  }

  @override
  void dispose() {
    win = false;
    setState(() {});
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    level = widget.level;
    // levelType();
    // init level
    refreshLevel();
  }

  void refreshLevel() {
    levelType();
    levelCardFlips();
    levelIsDone();

    if ((level == 5 || level == 6) && type.length <= 13) {
      extendSquare();
    }
    type
      ..addAll(List.from(type))
      ..shuffle();
    showCards();
  }

  void showCards() {
    isPause = true;
    setState(() {});
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      print('flip');
      cardFlips = switch (level) {
        1 => List.generate(8, (index) => true),
        2 => List.generate(12, (index) => true),
        3 => List.generate(16, (index) => true),
        4 => List.generate(20, (index) => true),
        5 => List.generate(30, (index) => true),
        6 => List.generate(36, (index) => true),
        _ => List.generate(8, (index) => true),
      };
      setState(() {});
    });
    setState(() {});
    Future.delayed(Duration(seconds: level + 1), () {
      if (!mounted) return;
      print('flip');
      isPause = false;

      levelCardFlips();
      setState(() {});
    });
  }

  void extendSquare() {
    if (level == 5) {
      final extendSquare = List.generate(13, (index) => index + 1);
      extendSquare.shuffle();
      type.addAll(extendSquare.sublist(0, 2));
      return;
    }
    final extendSquare = List.generate(13, (index) => index + 1);
    extendSquare.shuffle();
    type.addAll(extendSquare.sublist(0, 5));
  }

  // Game Status
  Future<void> isWon() async {
    if (isDone.where((element) => element == false).isNotEmpty) return;
    status = ZnGameStatus.won;
    title = 'Congratulations!';
    win = true;
    setState(() {});
    final model = ZnSettingsProvider.read(context)!.model;
    if (model.score < score) await model.setScore(score);
  }

  Future<void> isLose() async {
    if (life > 0) return;
    status = ZnGameStatus.lose;
    title = 'OOOHHH...';
    textOpacity = 1;
    setState(() {});
    final model = ZnSettingsProvider.read(context)!.model;
    if (model.score < score) await model.setScore(score);
  }

  // Buttons pressed
  void onTryAgainPressed() {
    level = ZnSettingsProvider.read(context)!.model.level;
    title = '';
    selectedIndex = -1;
    success = null;
    isPause = false;
    life = 3;
    score = 0;
    status = ZnGameStatus.playing;
    refreshLevel();
    setState(() {});
  }

  void onItemPressed(int itemIndex) async {
    final model = ZnSettingsProvider.read(context)!.model;
    if (model.sound) AudioPlayer().play(AssetSource('audio/sound_default.wav'));
    if (isPause || isDone[itemIndex] || selectedIndex == itemIndex) return;
    setState(() {
      cardFlips[itemIndex] = !cardFlips[itemIndex];
    });
    if (selectedIndex == -1) {
      // if item is not selected
      selectedIndex = itemIndex;
      title = 'Find a pair card';
      success = null;
    } else if (type[selectedIndex] != type[itemIndex]) {
      // if items isn't same
      success = false;
      isPause = true;
      title = '-1 EXTRA DIAMOND';
      Future.delayed(const Duration(milliseconds: 500), () async {
        isPause = false;
        cardFlips[itemIndex] = false;
        cardFlips[selectedIndex] = false;
        selectedIndex = -1;
        life--;
        textOpacity = 1;
        setState(() {});
        await isLose();
        Timer(const Duration(seconds: 1), () {
          setState(() {
            textOpacity = 0;
          });
        });
      });
    } else if (type[selectedIndex] == type[itemIndex]) {
      // if items is same
      final isDoneIndex = selectedIndex;
      selectedIndex = -1;
      success = true;
      isPause = true;
      title = '+10 POINTS';

      score += 10;
      await model.setMoney(10);
      Future.delayed(const Duration(milliseconds: 500), () async {
        isPause = false;
        isDone[isDoneIndex] = true;
        isDone[itemIndex] = true;
        success = null;
        textOpacity = 1;
        setState(() {});
        await isWon();
        Timer(const Duration(seconds: 1), () {
          setState(() {
            textOpacity = 0;
          });
        });
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //! final model = SettingsProvider.watch(context).model;
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ZnAppImages.background1),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          toolbarHeight: 80,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Score: $score',
                style: const TextStyle(
                    fontFamily: 'Baloo 2',
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: 1),
              ),
              const SizedBox(),
              LevelAppBar(level: level),
              // ZnScoreWidget(score: score),
              Row(children: [
                Image.asset(
                    life >= 1 ? ZnAppImages.diamond : ZnAppImages.diamondBack,
                    width: 24.w,
                    height: 24.w,
                    fit: BoxFit.contain),
                SizedBox(width: 6.w),
                Image.asset(
                    life >= 2 ? ZnAppImages.diamond : ZnAppImages.diamondBack,
                    width: 24.w,
                    height: 24.w,
                    fit: BoxFit.contain),
                SizedBox(width: 6.w),
                Image.asset(
                    life >= 3 ? ZnAppImages.diamond : ZnAppImages.diamondBack,
                    width: 24.w,
                    height: 24.w,
                    fit: BoxFit.contain),
              ]),
            ],
          ),
        ),
        body: Column(
          // alignment: Alignment.center,
          // mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (life > 0) const SizedBox(height: 50),
            if (life > 0)
              AnimatedOpacity(
                duration: const Duration(seconds: 1),
                opacity: textOpacity,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

            if (life > 0) const Spacer(),

            Align(
              alignment: Alignment.center,
              child: ZnMiddleWidget(
                status: status,
                type: type,
                cardFlips: cardFlips,
                isDone: isDone,
                success: success,
                level: level,
                onTryAgainPressed: onTryAgainPressed,
                onItemPressed: onItemPressed,
              ),
            ),
            // SizedBox(height: 100),
            // SizedBox(height: 20.h),
            const Spacer(),
            if (life > 0) const Spacer(),
            if (life <= 0)
              ZnCustomButton(
                onPressed: onTryAgainPressed,
                text: 'Try Again',
              ),
            if (win)
              ZnCustomButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                text: 'TO NEXT LEVEL',
              ),
            if (win) const SizedBox(height: 22),
            if (win)
              ZnCustomButton(
                onPressed: onTryAgainPressed,
                text: 'RESTART',
              ),
            // const SizedBox(height: 22),
            const SizedBox(height: 22),
            ZnCustomButton(
              onPressed: () => Navigator.pop(context),
              text: 'Lobby',
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }
}
