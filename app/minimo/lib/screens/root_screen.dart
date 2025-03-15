import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minimo/components/images/bottle_icon_component.dart';
import 'package:minimo/components/images/net_icon_component.dart';
import 'package:minimo/enums/bottom_navigation.dart';
import 'package:minimo/enums/user_role.dart';
import 'package:minimo/models/user_model.dart';
import 'package:minimo/providers/chat_provider.dart';
import 'package:minimo/providers/letter_provider.dart';
import 'package:minimo/providers/post_provider.dart';
import 'package:minimo/screens/home/item_store_screen.dart';
import 'package:minimo/screens/home/letter_box/letter_detail_screen.dart';
import 'package:minimo/screens/post/post_detail_screen.dart';
import 'package:minimo/screens/post/post_input_screen.dart';
import 'package:minimo/screens/post/post_list_screen.dart';
import 'package:minimo/screens/post/user_post_list_screen.dart';
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
  ValueNotifier<int> currentIndex = ValueNotifier<int>(BottomNavigation.HOME.index);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 알림 클릭 시 넘어온 데이터에 따라 화면 이동
      if (widget.data != null) {
        if (widget.data!['tag'] == 'chat') {
          currentIndex.value = BottomNavigation.CHAT.index;
          _moveChatRoom(NavigatorUtil.navigatorKey, widget.data!);

        } else if (widget.data!['tag'] == 'letter') {
          currentIndex.value = BottomNavigation.HOME.index;
          _moveLetterDetail(NavigatorUtil.navigatorKey, widget.data!);

        } else if (widget.data!['tag'] == 'comment' || widget.data!['tag'] == 'subComment') {
          currentIndex.value = BottomNavigation.POST.index;
          _movePostDetail(NavigatorUtil.navigatorKey, widget.data!);
        }
      }
    });

    _synchronizeFcmToken(NavigatorUtil.navigatorKey.currentContext!);
  }

  void _moveChatRoom(GlobalKey<NavigatorState> navigatorKey, Map<String, dynamic> data) async {
    try {
      final userId = navigatorKey.currentContext!.read<UserProvider>().userCache!.id;

      navigatorKey.currentState!.push(
          MaterialPageRoute(builder: (context) => ChatRoomScreen(roomId: int.parse(data['roomId']), userId: userId, otherUserId: int.parse(data['senderId']), otherUserNickname: data['senderNickname'],),)
      );

    } catch (e) {
      debugPrint('RootScreen moveChatRoom error: $e');
    }
  }

  void _moveLetterDetail(GlobalKey<NavigatorState> navigatorKey, Map<String, dynamic> data) async {
    try {
      final userId = navigatorKey.currentContext!.read<UserProvider>().userCache!.id;
      final letter = await navigatorKey.currentContext!.read<LetterProvider>().getLetterByUser(letterId: int.parse(data['letterId']), userId: userId, userRole: UserRole.SENDER);

      navigatorKey.currentState!.push(
          MaterialPageRoute(builder: (context) => LetterDetailScreen(letter: letter, userRole: UserRole.SENDER,),),
      );

    } catch (e) {
      debugPrint('RootScreen moveLetterDetail error: $e');
    }
  }

  void _movePostDetail(GlobalKey<NavigatorState> navigatorKey, Map<String, dynamic> data) async {
    try {
      int userId = navigatorKey.currentContext!.read<UserProvider>().userCache!.id;
      final post = await navigatorKey.currentContext!.read<PostProvider>().getPost(postId: int.parse(data['postId']), userId: userId);

      navigatorKey.currentState!.push(
        MaterialPageRoute(builder: (context) => PostDetailScreen(post: post),)
      );

    } catch (e) {
      debugPrint('RootScreen _movePostDetail error: $e');
    }
  }

  StreamSubscription<String>? _fcmSubscription;
  void _synchronizeFcmToken(BuildContext context) async {
    _fcmSubscription?.cancel();
    UserProvider userProvider = context.read<UserProvider>();

    _fcmSubscription = FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      if (userProvider.userCache != null) {
        userProvider.updateFcmToken(fcmToken: fcmToken);
      }
      debugPrint('FCM Refresh Token: $fcmToken');
    });

    final fcmToken = await FirebaseMessaging.instance.getToken();
    userProvider.updateFcmToken(fcmToken: fcmToken!);
    debugPrint('FCM Token: $fcmToken');
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentIndex,
      builder: (context, index, child) {
        return Scaffold(
          appBar: _renderAppBar(context, index),
          body: _renderScreen(index),
          bottomNavigationBar: _renderBottomNavigationBar(index),
          floatingActionButton: _renderFloatingActionButton(index),
        );
      }
    );
  }

  Widget _renderScreen(index) {
    final screens = [
      HomeScreen(),
      PostListScreen(),
      ChatListScreen(),
    ];

    return screens[index];
  }

  BottomNavigationBar _renderBottomNavigationBar(int index) {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: (index) {
        currentIndex.value = index;
      },
      items: [
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.house,
            size: 20,
          ),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.tableList,
            size: 20,
          ),
          label: '게시판',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.solidComments,
            size: 20,
          ),
          label: '채팅',
        ),
      ],
    );
  }

  AppBar? _renderAppBar(BuildContext context, int index) {
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
                  child: IntrinsicHeight(
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
                                style: AppStyle.getMediumTextStyle(context),
                              );
                            } else {
                              return Text(
                                '99+',
                                style: AppStyle.getMediumTextStyle(context),
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
                                style: AppStyle.getMediumTextStyle(context),
                              );
                            } else {
                              return Text(
                                '99+',
                                style: AppStyle.getMediumTextStyle(context),
                              );
                            }
                          },
                        ),
                        const SizedBox(width: 4),
                        const VerticalDivider(
                          thickness: 1.2,
                          indent: 3,
                          endIndent: 3,
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
              ),
            ],
          ),
        ),
        leadingWidth: 300,
      ),
      AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.create),
                  onPressed: () {
                    _sideNavigatorPush(PostInputScreen());
                  },
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == '작성한 게시글') {
                      _sideNavigatorPush(UserPostListScreen(isPostMine: true));
                    } else if (value == '댓글 단 게시글') {
                      _sideNavigatorPush(UserPostListScreen(isCommentMine: true));
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<String>(
                        value: '작성한 게시글',
                        child: Text(
                          '작성한 게시글',
                          style: AppStyle.getLittleButtonTextStyle(context, isPositive: false),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: '댓글 단 게시글',
                        child: Text(
                          '댓글 단 게시글',
                          style: AppStyle.getLittleButtonTextStyle(context, isPositive: false),
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '고민 게시판',
              maxLines: 1,
              style: AppStyle.getLargeTextStyle(context),
            ),
          ),
        ),
        leadingWidth: 200,
      ),
      AppBar(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '채팅',
              maxLines: 1,
              style: AppStyle.getLargeTextStyle(context),
            ),
          ),
        ),
        leadingWidth: 200,
      ),
    ];

    return appBars[index];
  }

  FloatingActionButton? _renderFloatingActionButton(int index) {
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
        child: FaIcon(
          FontAwesomeIcons.pencil,
          size: 20,
        ),
      ),
      null,
      null,
    ];

    return buttons[index];
  }

  void _sideNavigatorPush(Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).chain(
                CurveTween(curve: Curves.easeInOut),
              ),
            ),
            child: child,
          );
        },
      ),
    );
  }
}
