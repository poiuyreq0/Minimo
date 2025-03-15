import 'package:flutter/material.dart';
import 'package:minimo/utils/url_util.dart';
import 'package:minimo/styles/app_style.dart';

import 'intro_input_screen.dart';


class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PageView(
              onPageChanged: (int page) {
                setState(() {
                  currentIndex = page;
                });
              },
              children: [
                _introPage(
                  title: '미니모 - Mini Moment\n짝사랑의 작은 순간들',
                  content: '안녕하세요! 만나서 반갑습니다 :)\n미니모에 오신 것을 환영합니다.',
                  isImageSet: true,
                ),
                _introPage(
                  title: '마음을 전하고 싶은 사람이 있나요?',
                  content: '좋아하는 상대에게 마음을 담은 유리병 편지를 보내보세요 \u{1F970}',
                  subContent: '미니모에서 그 사람도 당신의 편지를 기다리고 있을지 몰라요 \u{1F97A}',
                ),
                _introPage(
                  title: '새로운 말동무를 원하시나요?',
                  content: '당신의 유리병 편지는 어디로든 갈 수 있어요 \u{1F30A}',
                  subContent: '유리병을 주운 누군가가 당신과 이야기하기를 원할지도 몰라요 \u{1F340}',
                  isButtonSet: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _pageIndicator(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _introPage({
    required String title,
    required String content,
    String? subContent,
    bool isImageSet = false,
    bool isButtonSet = false,
  }) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isImageSet)
                Image.asset(
                  UrlUtil.iconClear,
                  width: 200,
                  height: 200,
                ),
              const SizedBox(height: 48),
              Text(
                title,
                style: AppStyle.getLargeTextStyle(context),
              ),
              const SizedBox(height: 32),
              Text(
                content,
                style: AppStyle.getMediumTextStyle(context),
              ),
              const SizedBox(height: 16),
              if (subContent != null)
                Text(
                  subContent,
                  style: AppStyle.getMediumTextStyle(context),
                ),
            ],
          ),
        ),
        if (isButtonSet)
          Positioned(
            bottom: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(right: 32.0),
              child: ElevatedButton(
                style: AppStyle.getPositiveElevatedButtonStyle(context),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => IntroInputScreen(),
                      )
                  );
                },
                child: Text('시작하기'),
              ),
            ),
          ),
      ],
    );
  }

  Widget _pageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            width: currentIndex == index ? 20.0 : 8.0,
            height: 8.0,
            decoration: BoxDecoration(
              color: currentIndex == index ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(4.0),
            ),
          );
        },
      ),
    );
  }
}
