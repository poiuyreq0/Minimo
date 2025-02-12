import 'dart:io';

class UrlUtil {
  // static final String _domain = 'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:8080';
  static const String _domain = 'http://192.168.0.7:8080';
  // static const String _domain = 'http://3.36.241.194:8080';

  static String userApi = '$_domain/api-user';
  static String letterApi = '$_domain/api-letter';
  static String postApi = '$_domain/api-post';
  static String chatApi = '$_domain/api-chat';
  static String chatWebSocket = '$_domain/ws-chat';

  static const String icon = 'assets/icons/icon.png';
  static const String iconClear = 'assets/icons/icon_clear.png';
  static const String iconUnknownUser = 'assets/icons/icon_unknown_user.jpg';
  static const String iconNet = 'assets/icons/net.png';
  static const String iconBottle = 'assets/icons/bottle.png';

  static String getUserImageUrl(int userId) {
    return '$userApi/users/$userId/image';
  }
}