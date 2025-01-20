class UrlUtil {
  // static const String domain = 'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:8080';
  static const String _domain = 'http://192.168.0.7:8080';

  static const String userApi = '$_domain/api/user';
  static const String letterApi = '$_domain/api/letter';
  static const String chatApi = '$_domain/api/chat';
  static const String chatWebSocket = '$_domain/ws-chat';

  static const String icon = 'assets/icons/icon.png';
  static const String iconClear = 'assets/icons/icon_clear.png';
  static const String iconUnknownUser = 'assets/icons/icon_unknown_user.jpg';
  static const String iconNet = 'assets/icons/net.png';
  static const String iconBottle = 'assets/icons/bottle.png';

  static String getUserImageUrl(int userId) {
    return '$userApi/$userId/image';
  }
}