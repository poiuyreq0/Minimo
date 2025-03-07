import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image/image.dart' as img;
import 'package:minimo/enums/letter_state.dart';
import 'package:minimo/providers/chat_provider.dart';
import 'package:minimo/providers/letter_provider.dart';
import 'package:minimo/providers/post_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/utils/dio_util.dart';
import 'package:minimo/screens/auth_screen.dart';
import 'package:minimo/utils/url_util.dart';
import 'package:provider/provider.dart';

class NotificationUtil {
  static final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const defaultChannelId = 'minimo_channel_id';
  static const defaultChannelName = '알림';

  static const chatChannelId = 'minimo_chat_channel_id';
  static const chatChannelName = '채팅';
  static const chatTag = 'chat';
  static const chatGroupKey = 'minimo_chat_group_key';

  static const letterChannelId = 'minimo_letter_channel_id';
  static const letterChannelName = '편지';
  static const letterTag = 'letter';

  static const commentChannelId = 'minimo_comment_channel_id';
  static const commentChannelName = '댓글';
  static const commentTag = 'comment';

  static const subCommentChannelId = 'minimo_sub_comment_channel_id';
  static const subCommentChannelName = '대댓글';
  static const subCommentTag = 'subComment';

  static void initializeNotification(GlobalKey<NavigatorState> navigatorKey) async {
    // Flutter Local Notifications

    // 일반 알림 채널 생성
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
        const AndroidNotificationChannel(
          defaultChannelId,
          defaultChannelName,
          importance: Importance.high,
        ));

    // chat 알림 채널 생성
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
        const AndroidNotificationChannel(
          chatChannelId,
          chatChannelName,
          importance: Importance.max,
        ));

    // letter 알림 채널 생성
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
        const AndroidNotificationChannel(
          letterChannelId,
          letterChannelName,
          importance: Importance.max,
        ));

    // comment 알림 채널 생성
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
        const AndroidNotificationChannel(
          commentChannelId,
          commentChannelName,
          importance: Importance.max,
        ));

    // subComment 알림 채널 생성
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
        const AndroidNotificationChannel(
          subCommentChannelId,
          subCommentChannelName,
          importance: Importance.max,
        ));

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('icon'),
      ),
      onDidReceiveNotificationResponse: (details) {
        debugPrint('FCM | 포그라운드 백그라운드 메시지 알림 클릭: ${details.payload}');

        if (details.payload != null) {
          final data = jsonDecode(details.payload!);
          _fcmClickHandler(data, navigatorKey);
        }
      },
    );


    // Firebase Cloud Messaging (FCM)

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    messaging.setAutoInitEnabled(true);

    NotificationSettings settings = await messaging.requestPermission();
    debugPrint('FCM | User granted permission: ${settings.authorizationStatus}');

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // FCM | 앱 종료 후 메시지 알림 클릭
    NotificationAppLaunchDetails? details = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null) {
      if (details.notificationResponse != null) {
        if (details.notificationResponse!.payload != null) {
          debugPrint('FCM | 앱 종료 후 메시지 알림 클릭: ${details.notificationResponse!.payload}');
          final data = jsonDecode(details.notificationResponse!.payload!);
          _fcmClickHandler(data, navigatorKey);
        }
      }
    }

    FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
  }

  @pragma('vm:entry-point')
  static Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
    debugPrint('FCM | 백그라운드 메시지 수신: ${message.data}');

    await Firebase.initializeApp();

    if (message.data['tag'] == chatTag) {
      _showChatNotification(message);

    } else if (message.data['tag'] == letterTag) {
      _showLetterNotification(message);

    } else if (message.data['tag'] == commentTag) {
      _showCommentNotification(message);

    } else if (message.data['tag'] == subCommentTag) {
      _showSubCommentNotification(message);
    }
  }

  static StreamSubscription<RemoteMessage>? _fcmSubscription;
  static void fcmForegroundHandler(GlobalKey<NavigatorState> navigatorKey) async {
    _fcmSubscription?.cancel();

    _fcmSubscription = FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('FCM | 포그라운드 메시지 수신: ${message.data}');

      LetterProvider letterProvider = navigatorKey.currentContext!.read<LetterProvider>();
      ChatProvider chatProvider = navigatorKey.currentContext!.read<ChatProvider>();
      PostProvider postProvider = navigatorKey.currentContext!.read<PostProvider>();

      final currentRoomId = chatProvider.currentRoomIdCache;
      final currentPostId = postProvider.currentPostIdCache;

      // 현재 채팅방에 있지 않을 때
      if (message.data['tag'] == chatTag && currentRoomId != int.parse(message.data['roomId'])) {
        chatProvider.refreshChatListScreenNewChatRooms();
        _showChatNotification(message);

      } else if (message.data['tag'] == letterTag) {
        letterProvider.refreshLetterListScreenNewLetters();
        letterProvider.refreshLetterDetailScreen();
        _showLetterNotification(message);

      } else if (message.data['tag'] == commentTag || message.data['tag'] == subCommentTag) {
        // 현재 해당 게시글에 있을 때
        if (currentPostId == int.parse(message.data['postId'])) {
          postProvider.refreshPostDetailScreen();
        // 현재 해당 게시글에 있지 않을 때
        } else {
          if (message.data['tag'] == commentTag) {
            _showCommentNotification(message);
          } else if (message.data['tag'] == subCommentTag) {
            _showSubCommentNotification(message);
          }
        }
      }
    });
  }

  static void _fcmClickHandler(Map<String, dynamic> data, GlobalKey<NavigatorState> navigatorKey) {
    navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => AuthScreen(data: data),),
      (route) => false,
    );
  }

  static void _showChatNotification(RemoteMessage message) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final userIcon = await _getUserIcon(int.parse(message.data['senderId']));

    await flutterLocalNotificationsPlugin.show(
      int.parse(message.data['roomId']),
      null,
      null,
      NotificationDetails(
        android: AndroidNotificationDetails(
          chatChannelId,
          chatChannelName,
          importance: Importance.max,
          styleInformation: MessagingStyleInformation(
            Person(
              icon: ByteArrayAndroidIcon(userIcon),
              name: message.data['senderNickname'],
            ),
            messages: [
              Message(
                message.data['content'],
                DateTime.parse(message.data['createdDate']),
                null,
              ),
            ],
          ),
          groupKey: chatGroupKey,
          tag: chatTag,
        ),
      ),
      payload: jsonEncode(message.data),
    );

    final activeNotifications = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.getActiveNotifications() ?? [];
    if (activeNotifications.isNotEmpty && !await _isNotificationActive(id: 0, tag: chatTag, activeNotifications: activeNotifications)) {
      flutterLocalNotificationsPlugin.show(
        0,
        null,
        null,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            chatChannelId,
            chatChannelName,
            importance: Importance.max,
            priority: Priority.high,
            styleInformation: InboxStyleInformation(
              [],
              summaryText: '안 읽은 채팅방',
            ),
            groupKey: chatGroupKey,
            setAsGroupSummary: true,
            tag: chatTag,
          ),
        ),
      );
    }
  }

  static void _showLetterNotification(RemoteMessage message) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final userIcon = await _getUserIcon(int.parse(message.data['receiverId']));

    late final String title;
    late final String body;
    if (message.data['letterState'] == LetterState.RECEIVED.name) {
      title = '${message.data['receiverNickname']} 님이 편지를 받았어요 \u{1F970}';
      body = "상대방의 연결을 기다리는 중이에요 \u{23F3}";
    } else {
      title = '${message.data['receiverNickname']} 님이 편지를 연결했어요 \u{1F970}';
      body = "새로운 대화를 시작해 보세요 \u{1F4AC}";
    }

    await flutterLocalNotificationsPlugin.show(
      int.parse(message.data['letterId']),
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          letterChannelId,
          letterChannelName,
          importance: Importance.max,
          priority: Priority.high,
          tag: letterTag,
          largeIcon: ByteArrayAndroidBitmap(userIcon),
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  static void _showCommentNotification(RemoteMessage message) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final userIcon = await _getUserIcon(int.parse(message.data['writerId']));

    final title = '${message.data['writerNickname']} 님이 댓글을 남겼어요 \u{1F4AC}';
    final body = message.data['content'];

    await flutterLocalNotificationsPlugin.show(
      int.parse(message.data['postId']),
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          commentChannelId,
          commentChannelName,
          importance: Importance.max,
          priority: Priority.high,
          tag: commentTag,
          largeIcon: ByteArrayAndroidBitmap(userIcon),
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  static void _showSubCommentNotification(RemoteMessage message) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final userIcon = await _getUserIcon(int.parse(message.data['writerId']));

    final title = '${message.data['writerNickname']} 님이 대댓글을 남겼어요 \u{1F4AC}';
    final body = message.data['content'];

    await flutterLocalNotificationsPlugin.show(
      int.parse(message.data['postId']),
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          subCommentChannelId,
          subCommentChannelName,
          importance: Importance.max,
          priority: Priority.high,
          tag: subCommentTag,
          largeIcon: ByteArrayAndroidBitmap(userIcon),
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  static Future<Uint8List> _getUserIcon(int userId) async {
    final Dio dio = DioUtil.getDio();
    final resp = await dio.get(
      UrlUtil.getUserImageUrl(userId),
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );
    Uint8List bytes = resp.data;

    // 이미지 크롭
    img.Image image = img.decodeImage(bytes)!;
    if (!image.hasAlpha) {
      image = image.convert(alpha: image.maxChannelValue, numChannels: 4);
    }
    final convertImage = img.copyResizeCropSquare(image, size: image.width, radius: 200,);

    return img.encodePng(convertImage);
  }

  // chat notification id == chat room id
  // letter notification id == letter id
  static void cancelNotification(int id, String tag) async {
    final activeNotifications = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.getActiveNotifications() ?? [];

    if (await _isNotificationActive(id: id, tag: tag, activeNotifications: activeNotifications)) {
      await flutterLocalNotificationsPlugin.cancel(id, tag: tag);
    }

    if (tag == chatTag && activeNotifications.length == 1 && await _isNotificationActive(id: 0, tag: tag, activeNotifications: activeNotifications)) {
      flutterLocalNotificationsPlugin.cancel(0, tag: tag);
    }
  }

  static Future<bool> _isNotificationActive({
    required int id,
    required String tag,
    required List<ActiveNotification> activeNotifications,
  }) async {
    return activeNotifications.any((notification) => (notification.id == id && notification.tag == tag));
  }
}