import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:minimo/components/ads/banner_ad_component.dart';
import 'package:minimo/components/images/bottle_icon_component.dart';
import 'package:minimo/components/images/net_icon_component.dart';
import 'package:minimo/enums/bottom_navigation.dart';
import 'package:minimo/enums/user_role.dart';
import 'package:minimo/providers/chat_provider.dart';
import 'package:minimo/providers/letter_provider.dart';
import 'package:minimo/screens/home/item_store_screen.dart';
import 'package:minimo/screens/home/letter_box/letter_detail_screen.dart';
import 'package:minimo/utils/navigator_util.dart';
import 'package:minimo/utils/url_util.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/screens/home/home_screen.dart';
import 'package:minimo/screens/home/info/info_screen.dart';
import 'package:minimo/screens/home/letter_input_screen.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:provider/provider.dart';

import 'chat/chat_list_screen.dart';
import 'chat/chat_room_screen.dart';
import 'home/letter_box/letter_box_screen.dart';

class RootScreen extends StatefulWidget {
  final Map<String, dynamic>? data;

  const RootScreen({
    this.data,
    super.key
  });

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  int currentIndex = BottomNavigation.HOME.index;

  @override
  void initState() {
    super.initState();

    // 알림 클릭 시 넘어온 데이터에 따라 화면 이동
    if (widget.data != null) {
      if (widget.data!['tag'] == 'chat') {
        currentIndex = BottomNavigation.CHAT.index;
        _moveChatRoom(NavigatorUtil.navigatorKey, widget.data!);

      } else if (widget.data!['tag'] == 'letter') {
        currentIndex = BottomNavigation.HOME.index;
        _moveLetterDetail(NavigatorUtil.navigatorKey, widget.data!);
      }
    }

    _synchronizeFcmToken(NavigatorUtil.navigatorKey.currentContext!);
  }

  void _moveChatRoom(GlobalKey<NavigatorState> navigatorKey, Map<String, dynamic> data) async {
    int userId = navigatorKey.currentContext!.read<UserProvider>().userCache!.id;

    try {
      // 채팅방이 존재하는지 확인
      final checkedRoomId = await navigatorKey.currentContext!.read<ChatProvider>().checkChatRoomByUser(roomId: int.parse(data['roomId']), userId: userId);

      navigatorKey.currentState!.push(
          MaterialPageRoute(builder: (context) => ChatRoomScreen(roomId: checkedRoomId, userId: userId, otherUserId: data['senderId'], otherUserNickname: data['senderNickname'],),)
      );

    } catch (e) {
      debugPrint('RootScreen moveChatRoom error: $e');
    }
  }

  void _moveLetterDetail(GlobalKey<NavigatorState> navigatorKey, Map<String, dynamic> data) async {
    try {
      final letter = await navigatorKey.currentContext!.read<LetterProvider>().getLetterByUser(letterId: int.parse(data['letterId']));

      navigatorKey.currentState!.push(
          MaterialPageRoute(builder: (context) => LetterDetailScreen(letter: letter, userRole: UserRole.SENDER,),),
      );

    } catch (e) {
      debugPrint('RootScreen moveLetterDetail error: $e');
    }
  }

  void _synchronizeFcmToken(BuildContext context) async {
    UserProvider userProvider = context.read<UserProvider>();

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      userProvider.updateFcmToken(fcmToken: fcmToken);
      debugPrint('FCM Refresh Token: $fcmToken');

    }).onError((e) {
      debugPrint('FCM onTokenRefresh error: $e');
    });

    final fcmToken = await FirebaseMessaging.instance.getToken();
    userProvider.updateFcmToken(fcmToken: fcmToken!);
    debugPrint('FCM Token: $fcmToken');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _renderAppBar(context, currentIndex),
      body: IndexedStack(
        index: currentIndex,
        children: _renderScreen(),
      ),
      bottomNavigationBar: _renderBottomNavigationBar(),
      floatingActionButton: _renderFloatingActionButton(currentIndex),
    );
  }

  List<Widget> _renderScreen() {
    return [
      HomeScreen(),
      Placeholder(),
      ChatListScreen(),
    ];
  }

  BottomNavigationBar _renderBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.view_list),
          label: '게시판',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.forum),
          label: '채팅',
        ),
      ],
    );
  }

  AppBar? _renderAppBar(BuildContext context, int currentIndex) {
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
                    _sideNavigatorPush(LetterBoxScreen());
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {
                    _sideNavigatorPush(InfoScreen());
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
              Image.asset(UrlUtil.iconClear),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ItemStoreScreen(),
                      )
                  );
                },
                borderRadius: BorderRadius.circular(10),
                child: Ink(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                  decoration: AppStyle.getSubBoxDecoration(context),
                  child: Row(
                    children: [
                      NetIconComponent(),
                      const SizedBox(width: 4),
                      Selector<UserProvider, int>(
                        selector: (context, userProvider) => userProvider.userCache!.netNum,
                        builder: (context, netNum, child) {
                          if (netNum < 100) {
                            return Text(
                              '$netNum',
                              style: Theme.of(context).textTheme.titleMedium,
                            );
                          } else {
                            return Text(
                              '99+',
                              style: Theme.of(context).textTheme.titleMedium,
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      BottleIconComponent(),
                      const SizedBox(width: 4),
                      Selector<UserProvider, int>(
                        selector: (context, userProvider) => userProvider.userCache!.bottleNum,
                        builder: (context, bottleNum, child) {
                          if (bottleNum < 100) {
                            return Text(
                              '$bottleNum',
                              style: Theme.of(context).textTheme.titleMedium,
                            );
                          } else {
                            return Text(
                              '99+',
                              style: Theme.of(context).textTheme.titleMedium,
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 4),
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
        leadingWidth: 300,
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

    return appBars[currentIndex];
  }

  FloatingActionButton? _renderFloatingActionButton(int currentIndex) {
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
        child: Icon(Icons.create),
      ),
      null,
      null,
    ];

    return buttons[currentIndex];
  }

  void _sideNavigatorPush(Widget screen) {
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
