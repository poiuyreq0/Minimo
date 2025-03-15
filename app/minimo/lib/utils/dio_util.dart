import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DioUtil {
  static final _auth = FirebaseAuth.instance;
  static final Dio _dio = Dio();

  static Dio getDio() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? jwt = await _auth.currentUser!.getIdToken();
        if (jwt != null) {
          options.headers['Authorization'] = 'Bearer $jwt';
        }
        handler.next(options);
      },
    ));

    return _dio;
  }
}