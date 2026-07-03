import 'package:dio/dio.dart';
import '../network/dio_client.dart';
 
class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();
 
  final Dio _dio = DioClient.instance.dio;
 
  // Fungsi untuk mengambil seluruh data dari bin npoint.io
  Future<Response> getKatalogCocos() async {
    try {
      return await _dio.get('da6b0e86f1221b5ced21');
    } on DioException catch (e) {
      throw Exception('Failed to load log from npoint: ${e.message}');
    }
  }
}