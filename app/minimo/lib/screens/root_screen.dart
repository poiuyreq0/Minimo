import 'package:flutter/material.dart';
import 'package:minimo/components/heart_icon_component.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/screens/home/home_screen.dart';
import 'package:minimo/screens/home/info/info_screen.dart';
import 'package:minimo/screens/home/letter_input_screen.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:provider/provider.dart';

import 'chat/chat_list_screen.dart';
import 'home/letter_box/letter_box_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(currentIndex),
      body: IndexedStack(
        index: currentIndex,
        children: renderScreen(),
      ),
      bottomNavigationBar: renderBottomNavigationBar(),
      floatingActionButton: renderFloatingActionButton(),
    );
  }

  List<Widget> renderScreen() {
    return [
      HomeScreen(),
      Placeholder(),
      ChatListScreen(),
    ];
  }

  BottomNavigationBar renderBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.view_list,
          ),
          label: '게시판',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.forum,
          ),
          label: '채팅',
        ),
      ],
    );
  }

  AppBar? renderAppBar(int index) {
    List<AppBar?> appBars = [
      AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.mail),
                  onPressed: () {
                    sideNavigatorPush(LetterBoxScreen());
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {
                    sideNavigatorPush(InfoScreen());
                  },
                ),
              ],
            ),
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            children: [
              Image.asset('assets/icons/icon_clear.png'),
              SizedBox(width: 8,),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(10),
                child: Ink(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: AppStyle.getMainBoxDecoration(context).copyWith(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondaryFixedDim,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      HeartIconComponent(),
                      const SizedBox(width: 8),
                      Selector<UserProvider, int>(
                        selector: (context, userProvider) => userProvider.userCache!.heartNum,
                        builder: (context, heartNum, child) {
                          return Text(
                            '$heartNum',
                            style: Theme.of(context).textTheme.displayMedium,
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 16,
                        child: VerticalDivider(),
                      ),
                      Icon(
                        Icons.add_circle,
                        color: Theme.of(context).colorScheme.primary,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        leadingWidth: 200,
      ),
      null,
      AppBar(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '채팅',
              maxLines: 1,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        leadingWidth: 200,
      ),
    ];

    return appBars[index];
  }

  FloatingActionButton? renderFloatingActionButton() {
    List<FloatingActionButton?> buttons = [
      FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => LetterInputScreen(),
            )
          );
        },
        child: Icon(
          Icons.create,
        ),
      ),
      null,
      null,
    ];

    return buttons[currentIndex];
  }

  void sideNavigatorPush(Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // 오른쪽에서 시작
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }
}
