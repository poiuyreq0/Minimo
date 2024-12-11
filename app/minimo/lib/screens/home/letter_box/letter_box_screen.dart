import 'package:flutter/material.dart';
import 'package:minimo/components/little_title_component.dart';
import 'package:minimo/components/title_component.dart';
import 'package:minimo/enums/letter_state.dart';
import 'package:minimo/enums/user_role.dart';

import 'letter_list_screen.dart';

class LetterBoxScreen extends StatelessWidget {
  const LetterBoxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('편지함'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TitleComponent(
                title: '보낸 유리병 편지함',
              ),
            ),
            LittleTitleComponent(
              title: '흘러가는 편지들',
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LetterListScreen(
                        title: '흘러가는 편지들',
                        helpText: '아직 누군가에게 발견되지 않은 유리병 편지입니다.',
                        letterState: LetterState.SENT,
                        userRole: UserRole.SENDER,
                      ),
                    )
                );
              },
            ),
            LittleTitleComponent(
              title: '누군가 고민 중인 편지들',
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LetterListScreen(
                        title: '누군가 고민 중인 편지들',
                        helpText: '누군가를 만난 유리병 편지입니다.\n고민 중인 편지는 24시간 후 다시 바다로 떠나게 됩니다.',
                        letterState: LetterState.LOCKED,
                        userRole: UserRole.SENDER,
                      ),
                    )
                );
              },
            ),
            const Divider(
              height: 48,
              indent: 16,
              endIndent: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TitleComponent(
                title: '받은 유리병 편지함',
              ),
            ),
            LittleTitleComponent(
              title: '고민 중인 편지들',
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LetterListScreen(
                        title: '고민 중인 편지들',
                        helpText: '내가 건진 유리병 편지입니다.\n고민 중인 편지는 24시간 후 다시 바다로 떠나게 됩니다.',
                        letterState: LetterState.LOCKED,
                        userRole: UserRole.RECEIVER,
                      ),
                    )
                );
              },
            ),
            const Divider(
              height: 48,
              indent: 16,
              endIndent: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TitleComponent(
                title: '연결된 유리병 편지함',
              ),
            ),
            LittleTitleComponent(
              title: '나로부터 시작된 인연들',
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LetterListScreen(
                        title: '나로부터 시작된 인연들',
                        helpText: '유리병 편지로 연결된 인연입니다.\n용기 내어 대화를 시작해 보세요!',
                        letterState: LetterState.CONNECTED,
                        userRole: UserRole.SENDER,
                      ),
                    )
                );
              },
            ),
            LittleTitleComponent(
              title: '나에게로 다가온 인연들',
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LetterListScreen(
                        title: '나에게로 다가온 인연들',
                        helpText: '유리병 편지로 연결된 인연입니다.\n용기 내어 대화를 시작해 보세요!',
                        letterState: LetterState.CONNECTED,
                        userRole: UserRole.RECEIVER,
                      ),
                    )
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
