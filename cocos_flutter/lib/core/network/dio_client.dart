import 'package:dio/dio.dart';

class DioClient {
  DioClient._();
  static final DioClient instance = DioClient._();
  late final Dio dio;
 
  void init() {

    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.npoint.io/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }
}