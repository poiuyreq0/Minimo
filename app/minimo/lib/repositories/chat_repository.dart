import 'dart:io';

import 'package:dio/dio.dart';

class ChatRepository {
  final _dio = Dio();
  final _targetUrl = 'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:8080/api/chats';


}