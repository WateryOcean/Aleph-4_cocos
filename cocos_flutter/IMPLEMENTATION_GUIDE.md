# 📖 IMPLEMENTATION GUIDE - Step-by-Step dengan Contoh Kode
## Aleph-4 Cocos Flutter Backend dengan Dio

---

## 🎯 PANDUAN INI MENCAKUP:
1. Setup Awal dan Dependency Installation
2. Membuat API Client dengan Dio
3. JSON Parsing dan Model Generation
4. Repository Pattern dengan Dio
5. Provider State Management
6. Integrasi ke Views
7. Error Handling dan Interceptors
8. Testing dan Debugging

---

## BAGIAN 1: SETUP AWAL

### 1.1 Update pubspec.yaml

Buka file `pubspec.yaml` dan update dependencies section:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Existing
  google_fonts: ^8.0.2
  cupertino_icons: ^1.0.8
  intl: ^0.20.2
  shared_preferences: ^2.5.5

  # ✨ BARU - DIO & STATE MANAGEMENT
  dio: ^5.3.1              # HTTP client untuk API calls
  provider: ^6.0.0         # State management
  
  # ✨ OPTIONAL - untuk model generation
  json_annotation: ^4.8.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  
  # ✨ BARU - untuk code generation
  build_runner: ^2.4.6
  json_serializable: ^6.7.1

flutter:
  uses-material-design: true
  assets:
    - assets/
    - assets/logo_images/
    - assets/events_images/
    - assets/offer_images/
    - assets/product_images/
    - assets/welcome_images/
    - assets/product_images/anime_images/demonslayer_images/
    - assets/product_images/anime_images/onepiece_images/
    - assets/product_images/film_images/harrypott_images/
    - assets/product_images/film_images/starwars_images/
    - assets/product_images/game_images/eldenring_images/
    - assets/product_images/game_images/genshin_images/
```

### 1.2 Install Dependencies

Jalankan command di terminal:

```bash
# Get all dependencies
flutter pub get

# Alternative: tambah satu per satu
flutter pub add dio provider json_annotation
flutter pub add --dev build_runner json_serializable
```

### 1.3 Verify Installation

Cek apakah dependencies terinstall:

```bash
flutter pub list
```

Output harus menunjukkan:
- dio 5.3.1
- provider 6.0.0
- json_annotation 4.8.1

---

## BAGIAN 2: MEMBUAT API CLIENT DENGAN DIO

### 2.1 Buat Struktur Folder untuk Core Services

```bash
mkdir -p lib/core/services
```

### 2.2 Buat File: `lib/core/services/api_exception.dart`

```dart
/// Custom exception untuk API errors
class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic originalError;

  ApiException({
    this.statusCode,
    required this.message,
    this.originalError,
  });

  @override
  String toString() {
    return 'ApiException(statusCode: $statusCode, message: $message)';
  }

  /// Mengubah ApiException ke string yang user-friendly
  String get userMessage {
    switch (statusCode) {
      case 400:
        return 'Bad Request: $message';
      case 401:
        return 'Unauthorized: Please login again';
      case 403:
        return 'Forbidden: You do not have permission';
      case 404:
        return 'Not Found: Resource tidak ditemukan';
      case 500:
        return 'Server Error: Silakan coba lagi nanti';
      case 503:
        return 'Service Unavailable: Server sedang maintenance';
      default:
        return message.isEmpty ? 'Something went wrong' : message;
    }
  }
}
```

### 2.3 Buat File: `lib/core/services/dio_interceptors.dart`

```dart
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Logging Interceptor untuk debug
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('═══════════════════════════════════════════════════════');
    print('🔵 REQUEST: ${options.method} ${options.uri}');
    print('Headers: ${options.headers}');
    if (options.data != null) {
      print('Body: ${options.data}');
    }
    print('═══════════════════════════════════════════════════════');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('═══════════════════════════════════════════════════════');
    print('🟢 RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
    print('Data: ${response.data}');
    print('═══════════════════════════════════════════════════════');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('═══════════════════════════════════════════════════════');
    print('🔴 ERROR: ${err.response?.statusCode} ${err.requestOptions.uri}');
    print('Message: ${err.message}');
    print('Response: ${err.response?.data}');
    print('═══════════════════════════════════════════════════════');
    handler.next(err);
  }
}

/// Auth Interceptor untuk inject token ke setiap request
class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get token dari SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    // Jika ada token, tambahkan ke header
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Jika error 401 (unauthorized), bisa trigger logout
    if (err.response?.statusCode == 401) {
      print('Token expired atau invalid');
      // TODO: Trigger logout dan navigate ke login page
      // Bisa gunakan event bus atau navigator
    }
    handler.next(err);
  }
}

/// Error Interceptor untuk handling semua error
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Customize error handling di sini
    handler.next(err);
  }
}
```

### 2.4 Buat File: `lib/core/services/api_client.dart`

**Ini adalah CORE dari Dio integration!**

```dart
import 'package:dio/dio.dart';
import 'dio_interceptors.dart';
import 'api_exception.dart';

/// API Client utama untuk semua HTTP requests
class ApiClient {
  // ========== CONFIGURATION ==========
  static const String _baseUrl = 'https://api.example.com/v1';
  static const Duration _connectTimeout = Duration(seconds: 30);
  static const Duration _receiveTimeout = Duration(seconds: 30);
  static const Duration _sendTimeout = Duration(seconds: 30);

  // ========== SINGLETON PATTERN ==========
  static final ApiClient _instance = ApiClient._internal();

  static ApiClient get instance => _instance;

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    _initializeDio();
  }

  late Dio _dio;

  Dio get dio => _dio;

  // ========== INITIALIZATION ==========
  void _initializeDio() {
    final baseOptions = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      sendTimeout: _sendTimeout,
      responseType: ResponseType.json,
      contentType: 'application/json',
      validateStatus: (status) {
        // Don't throw error untuk status tertentu
        return status != null && status < 500;
      },
    );

    _dio = Dio(baseOptions);

    // Add interceptors
    _dio.interceptors.addAll([
      LoggingInterceptor(),    // Log semua requests/responses
      AuthInterceptor(),        // Inject token
      ErrorInterceptor(),       // Custom error handling
    ]);
  }

  // ========== GENERIC REQUEST METHODS ==========

  /// GET Request
  /// 
  /// Example:
  /// ```dart
  /// final response = await ApiClient.instance.get('/products');
  /// ```
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST Request
  /// 
  /// Example:
  /// ```dart
  /// final response = await ApiClient.instance.post(
  ///   '/auth/login',
  ///   data: {'email': 'user@example.com', 'password': '12345'},
  /// );
  /// ```
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT Request
  /// 
  /// Example:
  /// ```dart
  /// final response = await ApiClient.instance.put(
  ///   '/products/123',
  ///   data: {'name': 'Updated Name'},
  /// );
  /// ```
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PATCH Request
  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE Request
  /// 
  /// Example:
  /// ```dart
  /// final response = await ApiClient.instance.delete('/products/123');
  /// ```
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ========== RESPONSE HANDLING ==========

  /// Handle successful response
  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode == null) {
      throw ApiException(
        message: 'Invalid response received',
      );
    }

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      // Success response
      return response.data is Map<String, dynamic>
          ? response.data
          : {'data': response.data};
    } else if (response.statusCode! >= 400) {
      // Error response dari server
      final errorMsg = response.data?['message'] ?? 'Unknown error';
      throw ApiException(
        statusCode: response.statusCode,
        message: errorMsg,
      );
    }

    return response.data ?? {};
  }

  /// Handle error
  ApiException _handleError(DioException error) {
    String message = 'Something went wrong';
    int? statusCode;

    if (error.response != null) {
      statusCode = error.response?.statusCode;
      message = error.response?.data?['message'] ?? error.message ?? 'Error';
    } else if (error.type == DioExceptionType.connectionTimeout) {
      message = 'Connection timeout - check your internet';
    } else if (error.type == DioExceptionType.receiveTimeout) {
      message = 'Server response timeout';
    } else if (error.type == DioExceptionType.sendTimeout) {
      message = 'Request timeout';
    } else if (error.type == DioExceptionType.unknown) {
      message = 'Network error - check your internet connection';
    }

    return ApiException(
      statusCode: statusCode,
      message: message,
      originalError: error,
    );
  }

  // ========== UTILITY METHODS ==========

  /// Set custom header
  void setHeader(String key, String value) {
    _dio.options.headers[key] = value;
  }

  /// Remove header
  void removeHeader(String key) {
    _dio.options.headers.remove(key);
  }

  /// Set base URL (untuk switch environment)
  void setBaseUrl(String url) {
    _dio.options.baseUrl = url;
  }

  /// Set timeout
  void setTimeout(Duration duration) {
    _dio.options.connectTimeout = duration;
    _dio.options.receiveTimeout = duration;
    _dio.options.sendTimeout = duration;
  }

  /// Clear semua interceptors
  void clearInterceptors() {
    _dio.interceptors.clear();
  }
}
```

### 2.5 Test API Client

Buat file test sederhana di `lib/test_api.dart` untuk verify Dio bekerja:

```dart
import 'core/services/api_client.dart';

Future<void> testApiClient() async {
  try {
    // Test GET request
    final response = await ApiClient.instance.get('/products');
    print('API Response: $response');
  } catch (e) {
    print('Error: $e');
  }
}
```

---

## BAGIAN 3: JSON PARSING & MODELS

### 3.1 Update ProductModel dengan JSON Serialization

**File:** `lib/features/product/models/product_model.dart`

```dart
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

/// Model untuk Product dari API
/// 
/// JSON contoh dari backend:
/// ```json
/// {
///   "id": "p_001",
///   "name": "Product Name",
///   "category": "Anime",
///   "subcategory": "Demon Slayer",
///   "price": 150.00,
///   "rating": 4.8,
///   "image_url": "https://...",
///   "available_versions": ["1", "2"],
///   "materials": ["Cotton"],
///   "sizes": ["S", "M", "L"],
///   "description": "Product description"
/// }
/// ```
@JsonSerializable()
class ProductModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'category')
  final String category;

  @JsonKey(name: 'subcategory')
  final String subCategory;

  @JsonKey(name: 'price')
  final double price;

  @JsonKey(name: 'rating')
  final double rating;

  @JsonKey(name: 'image_url')
  final String imagePath;

  @JsonKey(name: 'available_versions')
  final List<String> availableVersions;

  @JsonKey(name: 'materials')
  final List<String> materials;

  @JsonKey(name: 'sizes')
  final List<String> sizes;

  @JsonKey(name: 'description')
  final String description;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.subCategory,
    required this.price,
    required this.rating,
    required this.imagePath,
    required this.availableVersions,
    required this.materials,
    required this.sizes,
    required this.description,
  });

  /// Dari JSON API ke Dart object
  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  /// Dari Dart object ke JSON (untuk request ke API)
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  @override
  String toString() =>
      'ProductModel(id: $id, name: $name, price: $price, rating: $rating)';
}

/// Generic API Response wrapper
/// 
/// Digunakan untuk parsing standard API response dari backend
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'data')
  final T? data;

  @JsonKey(name: 'statusCode')
  final int? statusCode;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}
```

### 3.2 Generate JSON Serialization

Jalankan command untuk generate `product_model.g.dart`:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Output seharusnya:
```
[INFO] Building package executable...
[INFO] Reading cached asset graph version, core count: 8
[INFO] Running build
[INFO] Generated 1 Dart file matching file pattern.
[INFO] RunBuilder build_runner:built_in_dart_sources for lib/features/product/models/product_model.dart: 3ms
```

### 3.3 Create UserModel untuk Auth

**File:** `lib/features/auth/models/user_model.dart`

```dart
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'full_name')
  final String fullName;

  @JsonKey(name: 'username')
  final String username;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'phone')
  final String phone;

  @JsonKey(name: 'gender')
  final String gender;

  @JsonKey(name: 'profile_picture')
  final String profilePicture;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.phone,
    required this.gender,
    required this.profilePicture,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

/// Auth request/response models
@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class LoginResponse {
  final String token;

  @JsonKey(name: 'refresh_token')
  final String? refreshToken;

  final UserModel user;

  LoginResponse({
    required this.token,
    this.refreshToken,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class RegisterRequest {
  @JsonKey(name: 'full_name')
  final String fullName;

  final String email;
  final String password;
  final String phone;
  final String gender;

  RegisterRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    required this.gender,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
```

Lalu generate:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## BAGIAN 4: REPOSITORY PATTERN DENGAN DIO

### 4.1 Create ProductRepository

**File:** `lib/features/product/data/product_repository.dart`

```dart
import 'package:cocos_flutter/core/services/api_client.dart';
import 'package:cocos_flutter/core/services/api_exception.dart';
import '../models/product_model.dart';

/// Abstract class untuk ProductRepository
abstract class ProductRepository {
  Future<List<ProductModel>> getAllProducts();
  Future<List<ProductModel>> getProductsByCategory(String category);
  Future<ProductModel> getProductDetail(String productId);
  Future<List<ProductModel>> searchProducts(String keyword);
}

/// Implementation dengan Dio API calls
class ProductRepositoryImpl implements ProductRepository {
  static const String _endpoint = '/products';

  /// Get semua products dari API
  /// 
  /// API call: GET /products
  /// Expected response:
  /// ```json
  /// {
  ///   "success": true,
  ///   "message": "Products fetched successfully",
  ///   "data": [
  ///     { "id": "1", "name": "Product 1", ... },
  ///     ...
  ///   ]
  /// }
  /// ```
  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await ApiClient.instance.get(_endpoint);

      // Parse response
      final List<dynamic> data = response['data'] ?? [];
      final products = data
          .map((product) => ProductModel.fromJson(product as Map<String, dynamic>))
          .toList();

      return products;
    } catch (e) {
      // Error handling akan dilakukan oleh Provider
      rethrow;
    }
  }

  /// Get products by category
  /// 
  /// API call: GET /products/category/:category
  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await ApiClient.instance.get(
        '$_endpoint/category/$category',
      );

      final List<dynamic> data = response['data'] ?? [];
      return data
          .map((product) => ProductModel.fromJson(product as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get detail satu product
  /// 
  /// API call: GET /products/:id
  @override
  Future<ProductModel> getProductDetail(String productId) async {
    try {
      final response = await ApiClient.instance.get(
        '$_endpoint/$productId',
      );

      return ProductModel.fromJson(response['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  /// Search products by keyword
  /// 
  /// API call: GET /products/search?q=:keyword
  @override
  Future<List<ProductModel>> searchProducts(String keyword) async {
    try {
      final response = await ApiClient.instance.get(
        '$_endpoint/search',
        queryParameters: {'q': keyword},
      );

      final List<dynamic> data = response['data'] ?? [];
      return data
          .map((product) => ProductModel.fromJson(product as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
```

### 4.2 Create AuthRepository

**File:** `lib/features/auth/data/auth_repository.dart`

```dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cocos_flutter/core/services/api_client.dart';
import 'package:cocos_flutter/core/services/api_exception.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(String email, String password);
  Future<UserModel> register(RegisterRequest request);
  Future<void> logout();
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<bool> isTokenValid();
}

class AuthRepositoryImpl implements AuthRepository {
  static const String _endpoint = '/auth';
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  /// Login dengan email dan password
  /// 
  /// API call: POST /auth/login
  /// Request body:
  /// ```json
  /// {
  ///   "email": "user@example.com",
  ///   "password": "password123"
  /// }
  /// ```
  /// Response:
  /// ```json
  /// {
  ///   "success": true,
  ///   "message": "Login successful",
  ///   "data": {
  ///     "token": "eyJhbGc...",
  ///     "refresh_token": "eyJhbGc...",
  ///     "user": { "id": "1", "name": "John", ... }
  ///   }
  /// }
  /// ```
  @override
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await ApiClient.instance.post(
        '$_endpoint/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      // Parse response
      final loginData = response['data'] as Map<String, dynamic>;
      final loginResponse = LoginResponse.fromJson(loginData);

      // Save token ke SharedPreferences
      await saveToken(loginResponse.token);

      // Save user data (optional)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, loginResponse.user.toString());

      return loginResponse;
    } catch (e) {
      rethrow;
    }
  }

  /// Register user baru
  /// 
  /// API call: POST /auth/register
  @override
  Future<UserModel> register(RegisterRequest request) async {
    try {
      final response = await ApiClient.instance.post(
        '$_endpoint/register',
        data: request.toJson(),
      );

      final userData = response['data'] as Map<String, dynamic>;
      return UserModel.fromJson(userData);
    } catch (e) {
      rethrow;
    }
  }

  /// Logout user
  @override
  Future<void> logout() async {
    try {
      // Call logout endpoint di backend (optional)
      // await ApiClient.instance.post('$_endpoint/logout');

      // Clear token dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
    } catch (e) {
      rethrow;
    }
  }

  /// Get token dari SharedPreferences
  @override
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      return null;
    }
  }

  /// Save token ke SharedPreferences
  @override
  Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    } catch (e) {
      rethrow;
    }
  }

  /// Check apakah token masih valid
  @override
  Future<bool> isTokenValid() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return false;
      }

      // Optional: call API to verify token
      final response = await ApiClient.instance.get('$_endpoint/verify');
      return response['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
```

---

## BAGIAN 5: PROVIDER STATE MANAGEMENT

### 5.1 ProductProvider

**File:** `lib/features/product/providers/product_provider.dart`

```dart
import 'package:flutter/material.dart';
import 'package:cocos_flutter/core/services/api_exception.dart';
import '../data/product_repository.dart';
import '../models/product_model.dart';

/// Provider untuk manage product state
/// 
/// Gunakan: context.read<ProductProvider>() atau context.watch<ProductProvider>()
class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository;

  ProductProvider(this._repository);

  // ========== STATE VARIABLES ==========
  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  List<ProductModel> _filteredProducts = [];
  List<ProductModel> get filteredProducts => _filteredProducts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ApiException? _error;
  ApiException? get error => _error;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  // ========== PUBLIC METHODS ==========

  /// Fetch semua products
  /// 
  /// Usage:
  /// ```dart
  /// await context.read<ProductProvider>().fetchAllProducts();
  /// ```
  Future<void> fetchAllProducts() async {
    _setLoading(true);
    _clearError();

    try {
      _products = await _repository.getAllProducts();
      _filteredProducts = List.from(_products);
      notifyListeners();
    } on ApiException catch (e) {
      _error = e;
      notifyListeners();
    }
  }

  /// Filter products by category
  /// 
  /// Usage:
  /// ```dart
  /// await context.read<ProductProvider>().fetchByCategory('Anime');
  /// ```
  Future<void> fetchByCategory(String category) async {
    _selectedCategory = category;
    _setLoading(true);
    _clearError();

    try {
      if (category.toLowerCase() == 'all') {
        _filteredProducts = List.from(_products);
      } else {
        _filteredProducts = await _repository.getProductsByCategory(category);
      }
      notifyListeners();
    } on ApiException catch (e) {
      _error = e;
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Search products
  /// 
  /// Usage:
  /// ```dart
  /// await context.read<ProductProvider>().searchProducts('Tanjiro');
  /// ```
  Future<void> searchProducts(String keyword) async {
    if (keyword.isEmpty) {
      _filteredProducts = List.from(_products);
      notifyListeners();
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      _filteredProducts = await _repository.searchProducts(keyword);
      notifyListeners();
    } on ApiException catch (e) {
      _error = e;
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Get single product detail
  /// 
  /// Bisa return dari list atau fetch dari API
  ProductModel? getProductDetail(String productId) {
    try {
      return _products.firstWhere((p) => p.id == productId);
    } catch (e) {
      return null;
    }
  }

  /// Refresh products (pull to refresh)
  Future<void> refreshProducts() async {
    await fetchAllProducts();
  }

  // ========== PRIVATE METHODS ==========

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(ApiException error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
```

### 5.2 AuthProvider

**File:** `lib/features/auth/providers/auth_provider.dart`

```dart
import 'package:flutter/material.dart';
import 'package:cocos_flutter/core/services/api_exception.dart';
import '../data/auth_repository.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  AuthProvider(this._repository);

  // ========== STATE ==========
  UserModel? _user;
  UserModel? get user => _user;

  String? _token;
  String? get token => _token;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  ApiException? _error;
  ApiException? get error => _error;

  // ========== INITIALIZATION ==========

  /// Check auth status saat app start
  /// 
  /// Call ini di main.dart atau splash screen
  /// ```dart
  /// await context.read<AuthProvider>().checkAuthStatus();
  /// ```
  Future<void> checkAuthStatus() async {
    _token = await _repository.getToken();
    _isAuthenticated = _token != null && _token!.isNotEmpty;
    notifyListeners();
  }

  // ========== AUTH METHODS ==========

  /// Login dengan email dan password
  /// 
  /// Usage:
  /// ```dart
  /// final success = await context.read<AuthProvider>().login(
  ///   'user@example.com',
  ///   'password123',
  /// );
  /// if (success) {
  ///   // Navigate to home
  /// }
  /// ```
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _repository.login(email, password);
      _token = response.token;
      _user = response.user;
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e;
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Register user baru
  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String gender,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final request = RegisterRequest(
        fullName: fullName,
        email: email,
        password: password,
        phone: phone,
        gender: gender,
      );
      _user = await _repository.register(request);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e;
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Logout
  /// 
  /// Usage:
  /// ```dart
  /// await context.read<AuthProvider>().logout();
  /// // Navigate to login
  /// ```
  Future<void> logout() async {
    _setLoading(true);

    try {
      await _repository.logout();
      _user = null;
      _token = null;
      _isAuthenticated = false;
      _clearError();
      notifyListeners();
    } catch (e) {
      // Still proceed dengan logout meski ada error
      _user = null;
      _token = null;
      _isAuthenticated = false;
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // ========== PRIVATE HELPERS ==========

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
```

---

## BAGIAN 6: INTEGRASI KE MAIN.dart

### 6.1 Update main.dart

**File:** `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/api_client.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/product/data/product_repository.dart';
import 'features/product/providers/product_provider.dart';
import 'routes/app_routes.dart';

void main() {
  // Initialize API Client
  ApiClient.instance;

  runApp(const CoCosApp());
}

class CoCosApp extends StatelessWidget {
  const CoCosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ========== REPOSITORIES (sebagai singleton) ==========
        Provider<AuthRepository>(
          create: (_) => AuthRepositoryImpl(),
        ),
        Provider<ProductRepository>(
          create: (_) => ProductRepositoryImpl(),
        ),

        // ========== PROVIDERS (state management) ==========
        /// Auth Provider - depends on AuthRepository
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            context.read<AuthRepository>(),
          ),
        ),

        /// Product Provider - depends on ProductRepository
        ChangeNotifierProvider(
          create: (context) => ProductProvider(
            context.read<ProductRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'CoCos - Cosplay Shop',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}
```

---

## BAGIAN 7: UPDATE VIEWS

### 7.1 Update HomePage dengan ProductProvider

**File:** `lib/features/home/home_page.dart` (snippet penting)

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../product/providers/product_provider.dart';
import '../product/models/product_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Fetch products saat page diload
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          // CASE 1: Loading
          if (productProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // CASE 2: Error
          if (productProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${productProvider.error!.userMessage}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductProvider>().fetchAllProducts();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // CASE 3: Empty
          if (productProvider.products.isEmpty) {
            return const Center(
              child: Text('No products available'),
            );
          }

          // CASE 4: Success - Show products
          return RefreshIndicator(
            onRefresh: () =>
                context.read<ProductProvider>().refreshProducts(),
            child: ListView.builder(
              itemCount: productProvider.products.length,
              itemBuilder: (context, index) {
                final product = productProvider.products[index];
                return ProductCard(product: product);
              },
            ),
          );
        },
      ),
    );
  }
}
```

### 7.2 Update LoginPage dengan AuthProvider

**File:** `lib/features/auth/views/login_page.dart` (snippet penting)

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../core/widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Get email dan password
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validate
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Call login dari provider
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(email, password);

    if (success) {
      // Navigate ke home
      if (mounted) {
        AppRoutes.loginSuccess(context);
      }
    } else {
      // Show error
      if (mounted) {
        final errorMessage = authProvider.error?.userMessage ?? 'Login failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Email field
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Password field
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 32),

                // Login button
                CustomButton(
                  text: authProvider.isLoading ? 'Loading...' : 'Login',
                  onPressed: authProvider.isLoading
                      ? null
                      : _handleLogin,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

---

## BAGIAN 8: TESTING & DEBUGGING

### 8.1 Tips Debugging API Calls

1. **Enable Logging Interceptor** - Sudah built-in di ApiClient
2. **Check Network Tab** - Gunakan flutter_logs package
3. **Verify API Response** - Gunakan Postman/Thunder Client
4. **Check Token** - Debug SharedPreferences values
5. **Print State Changes** - Add print statements di Provider

### 8.2 Common Issues & Solutions

**Issue 1: "Model.g.dart not found"**
```bash
# Solution:
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

**Issue 2: "401 Unauthorized"**
- Token belum disave atau expired
- Check AuthInterceptor dan token saving

**Issue 3: "Provider not updating UI"**
- Gunakan `Consumer` bukan `watch` di Consumer
- Atau gunakan `context.watch()` di build method

**Issue 4: "API Connection Timeout"**
- Check _baseUrl di ApiClient (harus valid API server)
- Check internet connection
- Increase timeout duration jika server lambat

---

## 🎓 NEXT STEPS SETELAH DIO

Setelah step ini selesai, lanjutkan dengan:

1. **LOCAL STORAGE (SQLite)** - Untuk cache data
2. **OFFLINE SUPPORT** - Bekerja tanpa internet
3. **FIREBASE AUTH** - Autentikasi social media
4. **FIREBASE REALTIME DB** - Chat dan notifications
5. **IMAGE UPLOAD** - Untuk profile picture / product images

---

## 📝 QUICK REFERENCE

### API Client Usage
```dart
// GET
final data = await ApiClient.instance.get('/products');

// POST
final response = await ApiClient.instance.post('/auth/login', 
  data: {'email': 'user@example.com', 'password': 'pass'});

// PUT
await ApiClient.instance.put('/users/123', 
  data: {'name': 'New Name'});

// DELETE
await ApiClient.instance.delete('/products/123');
```

### Provider Usage
```dart
// Read (one-time access)
final products = context.read<ProductProvider>().products;

// Watch (reactive)
context.watch<ProductProvider>();

// Consumer (widget-based)
Consumer<ProductProvider>(builder: (ctx, provider, child) {})
```

---

**Happy Coding! 🚀**
