# 🚀 BACKEND ROADMAP - Aleph-4 Cocos Flutter Project
## Dari Awal Sampai Implementasi DIO

**Status Project:** Semester 4 - Project Kelompok 2  
**Target:** Implementasi Backend dengan API DIO (hingga step ini saja)  
**Framework:** Flutter + Dart  
**Materi Pembelajaran:** Provider, API Integration, JSON Parsing, Dio, Local Storage, MVC Architecture

---

## 📋 DAFTAR ISI
1. [Analisis Project Saat Ini](#analisis-project-saat-ini)
2. [Teknologi yang Akan Digunakan](#teknologi-yang-akan-digunakan)
3. [Alur Pengerjaan Step-by-Step](#alur-pengerjaan-step-by-step)
4. [Struktur Folder yang Disarankan](#struktur-folder-yang-disarankan)
5. [Timeline dan Milestone](#timeline-dan-milestone)

---

## 📊 Analisis Project Saat Ini

### A. Struktur Existing

Project sudah memiliki:
- ✅ **Models Layer**: ProductModel, EventModel, ChatModel, OrderModel (data structures)
- ✅ **Views Layer**: UI screens untuk semua features (login, home, product detail, dll)
- ✅ **Basic Data Layer**: UserService (dengan SharedPreferences)
- ✅ **Dummy Data**: ProductDummyData untuk mock testing
- ✅ **Core Layer**: Theme, Constants, Utilities, Widgets
- ✅ **Routing**: AppRoutes dengan named routes yang terstruktur
- ✅ **Dependencies**: Google Fonts, SharedPreferences, Intl

### B. Teknologi Saat Ini

```yaml
# pubspec.yaml (dependencies existing)
flutter:
  sdk: flutter
google_fonts: ^8.0.2
cupertino_icons: ^1.0.8
intl: ^0.20.2
shared_preferences: ^2.5.5
```

### C. Status Features

| Feature | Status | Notes |
|---------|--------|-------|
| Auth (Login/Register) | UI Ready | Menggunakan dummy data + UserService |
| Product Listing | UI Ready | Menggunakan ProductDummyData |
| Product Detail | UI Ready | Static data |
| Cart | UI Ready | Hanya UI, logic belum ada |
| Checkout | UI Ready | Hanya UI |
| Events | UI Ready | Menggunakan dummy EventModel |
| Chat | UI Ready | Menggunakan dummy ChatModel |
| Orders | UI Ready | Hanya UI structure |
| Profile | UI Ready | Integrasi UserService |
| Search | UI Ready | Filter logic ada, tapi data dari dummy |

---

## 🛠 Teknologi yang Akan Digunakan

### 1. **Dio** (HTTP Client - WAJIB sampai step ini)
```dart
// Untuk membuat API requests ke backend
// - GET, POST, PUT, DELETE requests
// - Request/Response interceptors
// - Error handling
// - Request timeouts
// - File upload/download
```

### 2. **Provider** (State Management - OPTIONAL tapi disarankan)
```dart
// Untuk manajemen state aplikasi
// - ChangeNotifier untuk reactive updates
// - ProxyProvider untuk dependencies
// - Consumer widgets
```

### 3. **Freezed** (Model Generation - OPTIONAL)
```dart
// Untuk auto-generate model classes
// - copyWith, equality, toString
// - JSON serialization
```

### 4. **JSON Serializable** (JSON Parsing)
```dart
// Untuk parsing JSON ke Dart objects
// - fromJson, toJson methods
// - Type safety
```

### 5. **SQLite** (Local Storage - FUTURE step, tidak di roadmap ini)
```dart
// Untuk menyimpan data lokal di device
// - Database queries
// - CRUD operations
```

### 6. **Firebase** (Backend Alternative - FUTURE step, tidak di roadmap ini)
```dart
// Untuk autentikasi dan database
// - Firebase Auth
// - Firestore/Realtime Database
```

---

## 🎯 Alur Pengerjaan Step-by-Step

### FASE 1: SETUP & DEPENDENCY INSTALLATION (1-2 hari)

#### Step 1.1: Update pubspec.yaml dengan dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^8.0.2
  cupertino_icons: ^1.0.8
  intl: ^0.20.2
  shared_preferences: ^2.5.5
  
  # ===== BARU UNTUK BACKEND =====
  dio: ^5.3.1              # HTTP client
  provider: ^6.0.0         # State management
  freezed_annotation: ^2.4.1  # Model generation
  json_serializable: ^6.7.1   # JSON parsing
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  
  # ===== BARU UNTUK DEVELOPMENT =====
  build_runner: ^2.4.6     # Code generator
  freezed: ^2.4.1          # Freezed generator
```

**Command:**
```bash
flutter pub get
flutter pub add dio provider
flutter pub add --dev build_runner freezed
```

#### Step 1.2: Generate kode otomatis (jika menggunakan Freezed)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

### FASE 2: SETUP API CLIENT DENGAN DIO (2-3 hari)

#### Step 2.1: Buat API Client base class
**File:** `lib/core/services/api_client.dart`

```dart
import 'package:dio/dio.dart';

class ApiClient {
  static const String _baseUrl = 'https://api.example.com/v1';
  static const int _connectTimeout = 30000;
  static const int _receiveTimeout = 30000;

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(milliseconds: _connectTimeout),
      receiveTimeout: const Duration(milliseconds: _receiveTimeout),
      responseType: ResponseType.json,
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  )..interceptors.addAll([
    // Add logging interceptor
    LoggingInterceptor(),
    // Add auth interceptor (nanti untuk token management)
  ]);

  static Dio get dio => _dio;

  // Helper method untuk GET request
  static Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // Helper method untuk POST request
  static Future<Response> post(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      return await _dio.post(
        endpoint,
        data: data,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // Helper method untuk PUT request
  static Future<Response> put(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      return await _dio.put(
        endpoint,
        data: data,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // Helper method untuk DELETE request
  static Future<Response> delete(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      return await _dio.delete(
        endpoint,
        data: data,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

// Logging Interceptor untuk melihat request/response
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST: ${options.method} ${options.baseUrl}${options.path}');
    print('Headers: ${options.headers}');
    print('Body: ${options.data}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE: ${response.statusCode}');
    print('Data: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('ERROR: ${err.error}');
    print('Message: ${err.message}');
    handler.next(err);
  }
}

// Custom exception untuk API errors
class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic originalError;

  ApiException({
    this.statusCode,
    required this.message,
    this.originalError,
  });

  factory ApiException.fromDioException(DioException e) {
    String message = 'Something went wrong';
    int? statusCode;

    if (e.response != null) {
      statusCode = e.response?.statusCode;
      message = e.response?.data['message'] ?? e.message ?? 'Error';
    } else {
      message = e.message ?? 'Network error';
    }

    return ApiException(
      statusCode: statusCode,
      message: message,
      originalError: e,
    );
  }

  @override
  String toString() => 'ApiException(statusCode: $statusCode, message: $message)';
}
```

---

### FASE 3: MEMBUAT DATA MODELS DENGAN JSON PARSING (3-4 hari)

#### Step 3.1: Update ProductModel dengan JSON serialization

**File:** `lib/features/product/models/product_model.dart`

```dart
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  @JsonKey(name: 'id')
  final String id;
  
  @JsonKey(name: 'name')
  final String name;
  
  @JsonKey(name: 'category')
  final String category; // Anime, Game, Film
  
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

  // Auto-generated by json_serializable
  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}

// Response wrapper untuk API responses
@JsonSerializable()
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int? statusCode;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) =>
      ApiResponse(
        success: json['success'] as bool,
        message: json['message'] as String,
        data: json['data'] != null ? fromJsonT(json['data']) : null,
        statusCode: json['statusCode'] as int?,
      );
}
```

**Command untuk generate JSON serialization:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### Step 3.2: Update UserModel untuk Authentication

**File:** `lib/features/auth/models/user_model.dart`

```dart
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String phone;
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

// Auth Request/Response models
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
```

---

### FASE 4: MEMBUAT REPOSITORY LAYER (3-4 hari)

#### Step 4.1: Product Repository dengan Dio

**File:** `lib/features/product/data/product_repository.dart`

```dart
import 'package:dio/dio.dart';
import '../models/product_model.dart';
import '../../../core/services/api_client.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getAllProducts();
  Future<List<ProductModel>> getProductsByCategory(String category);
  Future<ProductModel> getProductDetail(String productId);
  Future<List<ProductModel>> searchProducts(String keyword);
}

class ProductRepositoryImpl implements ProductRepository {
  static const String _endpoint = '/products';

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await ApiClient.get(_endpoint);
      final jsonData = response.data as Map<String, dynamic>;
      
      final List<dynamic> products = jsonData['data'] ?? [];
      return products
          .map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await ApiClient.get(
        '$_endpoint/category/$category',
      );
      final jsonData = response.data as Map<String, dynamic>;
      
      final List<dynamic> products = jsonData['data'] ?? [];
      return products
          .map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProductModel> getProductDetail(String productId) async {
    try {
      final response = await ApiClient.get('$_endpoint/$productId');
      final jsonData = response.data as Map<String, dynamic>;
      
      return ProductModel.fromJson(jsonData['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String keyword) async {
    try {
      final response = await ApiClient.get(
        '$_endpoint/search',
        queryParameters: {'q': keyword},
      );
      final jsonData = response.data as Map<String, dynamic>;
      
      final List<dynamic> products = jsonData['data'] ?? [];
      return products
          .map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
```

#### Step 4.2: Auth Repository dengan Dio

**File:** `lib/features/auth/data/auth_repository.dart`

```dart
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../../../core/services/api_client.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(String email, String password);
  Future<UserModel> register(Map<String, dynamic> data);
  Future<void> logout();
  Future<String?> getToken();
  Future<void> saveToken(String token);
}

class AuthRepositoryImpl implements AuthRepository {
  static const String _endpoint = '/auth';
  static const String _tokenKey = 'auth_token';

  @override
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await ApiClient.post(
        '$_endpoint/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      
      final jsonData = response.data as Map<String, dynamic>;
      final loginResponse = LoginResponse.fromJson(jsonData['data']);
      
      // Save token ke SharedPreferences
      await saveToken(loginResponse.token);
      
      return loginResponse;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> register(Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.post(
        '$_endpoint/register',
        data: data,
      );
      
      final jsonData = response.data as Map<String, dynamic>;
      return UserModel.fromJson(jsonData['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    } catch (e) {
      rethrow;
    }
  }
}
```

---

### FASE 5: MEMBUAT PROVIDER UNTUK STATE MANAGEMENT (2-3 hari)

#### Step 5.1: Product Provider dengan Provider package

**File:** `lib/features/product/providers/product_provider.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../data/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository;

  ProductProvider(this._repository);

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // Fetch all products
  Future<void> fetchAllProducts() async {
    _setLoading(true);
    _clearError();
    
    try {
      _products = await _repository.getAllProducts();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Fetch by category
  Future<void> fetchByCategory(String category) async {
    _setLoading(true);
    _clearError();
    
    try {
      _products = await _repository.getProductsByCategory(category);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Search products
  Future<void> searchProducts(String keyword) async {
    _setLoading(true);
    _clearError();
    
    try {
      _products = await _repository.searchProducts(keyword);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
```

#### Step 5.2: Auth Provider

**File:** `lib/features/auth/providers/auth_provider.dart`

```dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../data/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  AuthProvider(this._repository);

  UserModel? _user;
  UserModel? get user => _user;

  String? _token;
  String? get token => _token;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  String? _error;
  String? get error => _error;

  // Check if already logged in
  Future<void> checkAuthStatus() async {
    _token = await _repository.getToken();
    _isAuthenticated = _token != null && _token!.isNotEmpty;
    notifyListeners();
  }

  // Login
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
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register
  Future<bool> register(Map<String, dynamic> data) async {
    _setLoading(true);
    _clearError();
    
    try {
      _user = await _repository.register(data);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout
  Future<void> logout() async {
    _setLoading(true);
    
    try {
      await _repository.logout();
      _user = null;
      _token = null;
      _isAuthenticated = false;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
```

---

### FASE 6: INTEGRASI KE VIEWS & TESTING (3-4 hari)

#### Step 6.1: Update main.dart dengan Provider

**File:** `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/product/data/product_repository.dart';
import 'features/product/providers/product_provider.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const CoCosApp());
}

class CoCosApp extends StatelessWidget {
  const CoCosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth Provider
        Provider<AuthRepository>(
          create: (_) => AuthRepositoryImpl(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            context.read<AuthRepository>(),
          ),
        ),
        
        // Product Provider
        Provider<ProductRepository>(
          create: (_) => ProductRepositoryImpl(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(
            context.read<ProductRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'CoCos',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}
```

#### Step 6.2: Update Home Page dengan Provider

**File:** `lib/features/home/home_page.dart` (snippet)

```dart
import 'package:provider/provider.dart';
import '../product/providers/product_provider.dart';

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch products saat page dimuat
      context.read<ProductProvider>().fetchAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (productProvider.error != null) {
            return Center(
              child: Text('Error: ${productProvider.error}'),
            );
          }

          return ListView.builder(
            itemCount: productProvider.products.length,
            itemBuilder: (context, index) {
              final product = productProvider.products[index];
              return ProductCard(product: product);
            },
          );
        },
      ),
    );
  }
}
```

---

## 📁 Struktur Folder yang Disarankan

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── enums.dart
│   ├── services/
│   │   ├── api_client.dart           # ← BARU: Dio client
│   │   └── dio_interceptors.dart     # ← BARU: Interceptors
│   ├── theme/
│   │   └── app_theme.dart
│   ├── utils/
│   │   ├── formatters.dart
│   │   ├── helpers.dart
│   │   └── navigation_helper.dart
│   └── widgets/
│       └── ...
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── auth_repository.dart  # ← BARU: Repository dengan Dio
│   │   │   └── user_service.dart
│   │   ├── models/
│   │   │   ├── user_model.dart       # ← UPDATE: Dengan JSON serialization
│   │   │   └── login_request.dart    # ← BARU: Request/Response models
│   │   ├── providers/
│   │   │   └── auth_provider.dart    # ← BARU: Provider
│   │   ├── views/
│   │   │   ├── login_page.dart       # ← UPDATE: Dengan Provider integration
│   │   │   ├── register_page.dart
│   │   │   └── signin_page.dart
│   │   └── widgets/
│   │
│   ├── product/
│   │   ├── data/
│   │   │   ├── product_repository.dart  # ← BARU: Repository dengan Dio
│   │   │   └── product_dummy.dart
│   │   ├── models/
│   │   │   └── product_model.dart       # ← UPDATE: Dengan JSON serialization
│   │   ├── providers/
│   │   │   └── product_provider.dart    # ← BARU: Provider
│   │   ├── views/
│   │   │   ├── product_detail_page.dart # ← UPDATE: Dengan Provider integration
│   │   │   └── product_list_page.dart
│   │   └── widgets/
│   │       └── product_card.dart
│   │
│   ├── cart/
│   │   ├── data/
│   │   │   └── cart_repository.dart     # ← BARU
│   │   ├── models/
│   │   │   └── cart_item_model.dart     # ← BARU
│   │   ├── providers/
│   │   │   └── cart_provider.dart       # ← BARU
│   │   └── views/
│   │       └── cart_page.dart
│   │
│   ├── events/
│   ├── chat/
│   ├── checkout/
│   ├── orders/
│   ├── profile/
│   ├── search/
│   └── welcome/
│
├── routes/
│   └── app_routes.dart
│
├── main.dart                           # ← UPDATE: Dengan Provider setup
└── gen/                                # ← GENERATED: Dari build_runner

pubspec.yaml                             # ← UPDATE: Dengan new dependencies
```

---

## ⏱️ Timeline dan Milestone

### **Minggu 1: Foundation (Setup & API Client)**
- ✅ Day 1-2: Update dependencies, setup project structure
- ✅ Day 3-4: Buat API Client dengan Dio dan interceptors
- ✅ Day 5: Testing API Client dengan postman/thunder client

### **Minggu 2: Models & Repositories**
- ✅ Day 1-2: Update models dengan JSON serialization
- ✅ Day 3-4: Buat repositories untuk Auth dan Product
- ✅ Day 5: Testing repositories dengan mock API

### **Minggu 3: State Management & Integration**
- ✅ Day 1-2: Setup Provider dan buat providers
- ✅ Day 3-4: Integrasi providers ke views (Home, Product Detail)
- ✅ Day 5: Integrasi auth provider ke login/register

### **Minggu 4: Testing & Refinement**
- ✅ Day 1-3: Testing semua features dengan real API
- ✅ Day 4: Error handling dan edge cases
- ✅ Day 5: Documentation dan code review

---

## 📝 Checklist Implementasi

### Phase 1: Setup
- [ ] Update pubspec.yaml dengan Dio dan Provider
- [ ] Run flutter pub get
- [ ] Struktur folder sudah sesuai
- [ ] ApiClient sudah siap

### Phase 2: Models & JSON
- [ ] ProductModel dengan JSON serialization
- [ ] UserModel dengan JSON serialization
- [ ] LoginRequest/Response models
- [ ] Generate JSON files dengan build_runner

### Phase 3: Repositories
- [ ] ProductRepository dengan Dio
- [ ] AuthRepository dengan Dio dan token saving
- [ ] Error handling di repositories
- [ ] Interceptors untuk token injection

### Phase 4: Providers
- [ ] ProductProvider dengan ChangeNotifier
- [ ] AuthProvider dengan ChangeNotifier
- [ ] CartProvider (jika diperlukan)
- [ ] MultiProvider setup di main.dart

### Phase 5: Integration
- [ ] Update HomePage dengan ProductProvider
- [ ] Update LoginPage dengan AuthProvider
- [ ] Update ProductDetailPage dengan Provider
- [ ] Navigation handling untuk authenticated/unauthenticated

### Phase 6: Testing & Debugging
- [ ] Test API calls dengan Dio
- [ ] Test state management dengan Provider
- [ ] Test error handling
- [ ] Test offline scenarios

---

## 🚨 Common Issues & Solutions

### Issue 1: "Model.g.dart file not generated"
**Solution:**
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue 2: "Dio error response handling"
**Solution:** Gunakan custom exception dan proper error handling di repositories

### Issue 3: "Token not being sent with requests"
**Solution:** Gunakan interceptor untuk auto-inject token ke header

### Issue 4: "Provider not updating UI"
**Solution:** Pastikan menggunakan `Consumer` atau `context.watch()` di widget

---

## 📚 Resources & References

- [Dio Documentation](https://pub.dev/packages/dio)
- [Provider Package](https://pub.dev/packages/provider)
- [JSON Serializable](https://pub.dev/packages/json_serializable)
- [Flutter API Integration Best Practices](https://docs.flutter.dev/cookbook/networking/fetch-data)
- [Clean Architecture in Flutter](https://resocoder.com/flutter-clean-architecture)

---

## 📞 Support & Questions

Jika ada yang kurang jelas, bisa ditanyakan di:
- GitHub Issues
- Discord/Slack team
- Regular sync meetings

---

**Last Updated:** 2026-06-04  
**Status:** Ready for Implementation
