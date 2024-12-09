import 'package:flutter/material.dart';
import 'package:minimo/styles/app_style.dart';

import 'intro_input_screen.dart';


class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late final PageController pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (int page) {
                setState(() {
                  currentPage = page;
                });
              },
              children: [
                introPage(
                  title: 'Mini Moment\n짝사랑의 작은 순간들',
                  content: '안녕하세요! 만나서 반갑습니다.\nMinimo에 오신 것을 진심으로 환영합니다.',
                  subContent: '',
                ),
                introPage(
                  title: '마음을 표현하고 싶은 사람이 있나요?',
                  content: '좋아하는 상대에게 마음을 담은 유리병 편지를 보내보세요.',
                  subContent: 'Minimo에서 그 사람도 당신의 유리병을 기다리고 있을지 몰라요.',
                ),
                introPage(
                  title: '새로운 말동무를 원하시나요?',
                  content: '당신의 유리병 편지는 어디로든 갈 수 있어요.',
                  subContent: '유리병 편지를 주운 누군가가 당신과 이야기하길 원할지도 몰라요.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          pageIndicator(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget introPage({
    required String title,
    required String content,
    required String subContent,
  }) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (currentPage == 0)
                Image.asset(
                  'assets/icons/icon_clear.png',
                  width: 200,
                  height: 200,
                ),
              const SizedBox(height: 48),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 32),
              Text(
                content,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                subContent,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
        if (currentPage == 2)
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

  Widget pageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: currentPage == index ? 20.0 : 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: currentPage == index ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(4.0),
          ),
        );
      }),
    );
  }
}
