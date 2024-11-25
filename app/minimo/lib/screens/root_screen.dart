import 'package:flutter/material.dart';
import 'package:minimo/components/heart_icon_component.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/screens/home_screen.dart';
import 'package:minimo/screens/info_screen.dart';
import 'package:minimo/screens/letter_input_screen.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:provider/provider.dart';

import 'letter_box_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      vsync: this,
    );

    _tabController.addListener(tabListener);
  }

  tabListener() {
    // 슬라이드 이동 시, BottomNavigationBar 동기화
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(_tabController.index),
      body: TabBarView(
        controller: _tabController,
        children: renderChildren(),
      ),
      bottomNavigationBar: renderBottomNavigationBar(),
      floatingActionButton: renderFloatingActionButton(_tabController.index),
    );
  }

  List<Widget> renderChildren() {
    return [
      HomeScreen(),
      Placeholder(),
      Placeholder(),
    ];
  }

  BottomNavigationBar renderBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _tabController.index,
      onTap: (index) {
        // 탭 하여 이동 시, 페이지 동기화
        setState(() {
          _tabController.animateTo(index);
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
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: AppStyle.getMainBoxDecoration(context),
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
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
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/icons/icon_clear.png'),
        ),
        leadingWidth: 90,
      ),
      null,
      null,
    ];

    return appBars[index];
  }

  FloatingActionButton? renderFloatingActionButton(int index) {
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

    return buttons[index];
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
