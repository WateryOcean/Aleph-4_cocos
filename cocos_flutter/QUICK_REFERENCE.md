# ⚡ QUICK REFERENCE - Backend Implementation dengan DIO
## Aleph-4 Cocos Flutter Project

---

## 📌 3 LANGKAH AWAL

### 1️⃣ Install Dependencies
```bash
flutter pub add dio provider
flutter pub add --dev build_runner json_serializable
flutter pub get
```

### 2️⃣ Create API Client Structure
```
lib/core/services/
├── api_client.dart
├── api_exception.dart
└── dio_interceptors.dart
```

### 3️⃣ Setup MultiProvider di main.dart
```dart
MultiProvider(
  providers: [
    Provider<AuthRepository>(create: (_) => AuthRepositoryImpl()),
    Provider<ProductRepository>(create: (_) => ProductRepositoryImpl()),
    ChangeNotifierProvider(create: (ctx) => AuthProvider(ctx.read())),
    ChangeNotifierProvider(create: (ctx) => ProductProvider(ctx.read())),
  ],
  child: MaterialApp(...),
)
```

---

## 🏗️ ARCHITECTURE LAYERS

```
┌─────────────────────────────────────┐
│          UI LAYER (Views)           │
│  LoginPage, HomePage, ProductDetail │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│     PROVIDER LAYER (State Mgmt)     │
│  AuthProvider, ProductProvider, ... │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│    REPOSITORY LAYER (Business)      │
│  AuthRepository, ProductRepository  │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│       API CLIENT LAYER (HTTP)       │
│  Dio + Interceptors + Error Handling│
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│        MODELS LAYER (Data)          │
│  ProductModel, UserModel, ...       │
└─────────────────────────────────────┘
```

---

## 💻 CODE TEMPLATES

### 1. API Client (Skeleton)
```dart
// lib/core/services/api_client.dart
class ApiClient {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.example.com/v1',
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
  ))..interceptors.addAll([
    LoggingInterceptor(),
    AuthInterceptor(),
  ]);

  static Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await _dio.get(endpoint);
    return response.data;
  }

  static Future<Map<String, dynamic>> post(String endpoint, {Map? data}) async {
    final response = await _dio.post(endpoint, data: data);
    return response.data;
  }
}
```

### 2. Model dengan JSON
```dart
// lib/features/product/models/product_model.dart
@JsonSerializable()
class ProductModel {
  @JsonKey(name: 'id')
  final String id;
  
  @JsonKey(name: 'name')
  final String name;
  
  @JsonKey(name: 'price')
  final double price;

  ProductModel({required this.id, required this.name, required this.price});

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}

// Generate dengan: flutter pub run build_runner build
```

### 3. Repository
```dart
// lib/features/product/data/product_repository.dart
abstract class ProductRepository {
  Future<List<ProductModel>> getAllProducts();
}

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await ApiClient.instance.get('/products');
    final List data = response['data'] ?? [];
    return data.map((p) => ProductModel.fromJson(p)).toList();
  }
}
```

### 4. Provider
```dart
// lib/features/product/providers/product_provider.dart
class ProductProvider extends ChangeNotifier {
  final ProductRepository _repo;
  
  List<ProductModel> _products = [];
  bool _isLoading = false;
  String? _error;

  ProductProvider(this._repo);

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAll() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _products = await _repo.getAllProducts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### 5. View dengan Provider
```dart
// lib/features/home/home_page.dart
class HomePage extends StatefulWidget {
  @override
  void initState() {
    context.read<ProductProvider>().fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (ctx, provider, _) {
        if (provider.isLoading) return LoadingWidget();
        if (provider.error != null) return ErrorWidget(provider.error!);
        
        return ListView.builder(
          itemCount: provider.products.length,
          itemBuilder: (ctx, i) => ProductCard(provider.products[i]),
        );
      },
    );
  }
}
```

---

## 🔄 DATA FLOW DIAGRAM

```
User Action (Tap Button)
         │
         ▼
View (HomePage)
         │
         ▼
Provider.method() ◄─── context.read<ProductProvider>().fetchAll()
         │
         ▼
Repository.method()
         │
         ▼
ApiClient.get('/products') ◄─── Dio HTTP call
         │
         ▼
Backend API Server
         │
         ▼
Response JSON ──────────────┐
         │                  │
         ▼                  │
ApiClient returns Map ──────┤
         │                  │
         ▼                  │
Repository parses JSON ─────┤
         │                  ▼
         ▼            ProductModel.fromJson()
_products = List<ProductModel>
         │
         ▼
Provider.notifyListeners()
         │
         ▼
Consumer<ProductProvider> rebuilds
         │
         ▼
ListView shows new products
```

---

## 📝 FILE NAMING CONVENTIONS

```
lib/features/[feature]/
├── data/
│   ├── [feature]_repository.dart       # Abstract + Implementation
│   ├── [feature]_dummy.dart            # For mock/dummy data
│   └── [feature]_service.dart          # If needed (helpers)
│
├── models/
│   ├── [feature]_model.dart            # Main model
│   ├── [feature]_model.g.dart          # Auto-generated
│   ├── [feature]_request.dart          # API request
│   └── [feature]_response.dart         # API response
│
├── providers/
│   └── [feature]_provider.dart         # State management
│
├── views/
│   ├── [feature]_page.dart             # Main screen
│   └── [feature]_detail_page.dart      # Detail screen
│
└── widgets/
    └── [feature]_card.dart             # Custom widgets
```

---

## ✅ DAILY CHECKLIST

### DAY 1: Setup
- [ ] Add dependencies to pubspec.yaml
- [ ] Run flutter pub get
- [ ] Create core/services folder
- [ ] Create api_client.dart skeleton
- [ ] Test basic GET request

### DAY 2-3: Models & JSON
- [ ] Update ProductModel with @JsonSerializable
- [ ] Create UserModel with JSON
- [ ] Create request/response models
- [ ] Run build_runner
- [ ] Verify .g.dart files created

### DAY 4-5: Repositories
- [ ] Create ProductRepository
- [ ] Create AuthRepository
- [ ] Implement all methods
- [ ] Test with API calls

### DAY 6-7: Providers
- [ ] Create AuthProvider
- [ ] Create ProductProvider
- [ ] Add all methods
- [ ] Test state updates

### DAY 8-9: Integration
- [ ] Update main.dart with MultiProvider
- [ ] Update HomePage with ProductProvider
- [ ] Update LoginPage with AuthProvider
- [ ] Test end-to-end flow

### DAY 10: Testing & Polish
- [ ] Test error scenarios
- [ ] Test loading states
- [ ] Test token management
- [ ] Code review & cleanup

---

## 🚨 ERROR MESSAGES & FIXES

| Error | Cause | Fix |
|-------|-------|-----|
| `.g.dart file not found` | Models not generated | `flutter pub run build_runner build` |
| `Type 'X' not found` | Import missing | Add `import 'package:...';` |
| `Provider not updating UI` | Using wrong Consumer | Use `Consumer<X>` or `context.watch<X>()` |
| `401 Unauthorized` | Token invalid | Check AuthInterceptor, verify token saving |
| `Connection timeout` | API not responding | Check base URL, internet connection |
| `JSON parsing error` | Model mismatch | Check API response format, update model |
| `State not persisting` | Not saving to SharedPrefs | Add save logic in repository |

---

## 🎯 PERFORMANCE TIPS

```dart
// ❌ WRONG - Rebuilds entire widget tree
Consumer<ProductProvider>(builder: (ctx, provider, _) {
  return Column(
    children: [
      Text(provider.products.length.toString()),  // Triggers full rebuild
      ListView(...),
    ],
  );
});

// ✅ CORRECT - Only rebuilds affected part
Consumer<ProductProvider>(
  selector: (ctx, provider) => provider.products.length,
  builder: (ctx, count, _) => Text(count.toString()),
);
```

```dart
// ❌ WRONG - Creates new list every time
notifyListeners(); // Called even if data didn't change

// ✅ CORRECT - Only notify when data actually changed
if (_products != newProducts) {
  _products = newProducts;
  notifyListeners();
}
```

---

## 🔐 SECURITY TIPS

1. **Never hardcode API URLs**
   ```dart
   // Use environment variables atau config
   const String baseUrl = String.fromEnvironment('API_URL');
   ```

2. **Token Management**
   ```dart
   // Always save token securely
   // Use flutter_secure_storage for sensitive data
   ```

3. **Error Messages**
   ```dart
   // Don't expose backend errors to user
   // Show user-friendly messages instead
   ```

4. **Request Validation**
   ```dart
   // Validate data before sending
   // Sanitize user inputs
   ```

---

## 📚 NEXT TOPICS (After DIO)

1. **SQLite** - Local database for caching
2. **Firebase Auth** - Social login integration
3. **Firebase Firestore** - Real-time database
4. **Notifications** - Push notifications setup
5. **Image Upload** - Handle file uploads
6. **WebSockets** - Real-time communication

---

## 🧠 KEY CONCEPTS SUMMARY

### Dio
- HTTP client untuk API requests
- Support GET, POST, PUT, DELETE, PATCH
- Interceptors untuk logging & auth
- Built-in error handling

### Provider
- State management solution
- ChangeNotifier for reactive updates
- Consumer for UI rebuilds
- Dependency injection support

### JSON Serialization
- Convert JSON to Dart objects
- Use @JsonSerializable annotation
- Auto-generate fromJson/toJson
- Type-safe data handling

### Repository Pattern
- Separates data access logic
- Makes code testable
- Easy to switch data sources
- Clean architecture

### MVC in Flutter
- Model = Data & Business Logic
- View = UI Components
- Controller = Provider/Logic Handler
- Keeps code organized

---

## 🎬 GETTING STARTED NOW

### Step 1: Update pubspec.yaml
```yaml
dependencies:
  dio: ^5.3.1
  provider: ^6.0.0
  json_annotation: ^4.8.1

dev_dependencies:
  build_runner: ^2.4.6
  json_serializable: ^6.7.1
```

### Step 2: Run dependencies
```bash
flutter pub get
```

### Step 3: Create API Client
Create `lib/core/services/api_client.dart` with basic Dio setup

### Step 4: Generate JSON
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 5: Create first Repository
Implement ProductRepository with getAllProducts()

### Step 6: Create Provider
Add ProductProvider with fetchAll() method

### Step 7: Integrate to Views
Update HomePage to use ProductProvider

### Step 8: Test!
Run the app and verify API calls working

---

## 📞 USEFUL RESOURCES

- [Dio GitHub](https://github.com/flutterchina/dio)
- [Provider Examples](https://github.com/rrousselGit/provider)
- [JSON Serializable Docs](https://pub.dev/packages/json_serializable)
- [Flutter API Documentation](https://api.flutter.dev)

---

## ✨ PRO TIPS

1. Use `build_runner watch` for auto-generate during development
2. Always implement error handling - never let exceptions bubble up
3. Use `copyWith()` for immutable objects (if using Freezed later)
4. Test API endpoints with Postman BEFORE integrating
5. Add logging to trace API calls during debugging
6. Use environment variables for different API URLs
7. Implement proper state management from the start
8. Write unit tests for repositories and providers

---

**Quick Links:**
- [Full Roadmap](./BACKEND_ROADMAP.md)
- [Implementation Guide](./IMPLEMENTATION_GUIDE.md)
- [Architecture & Checklist](./CHECKLIST_AND_ARCHITECTURE.md)
- [Main README](./README.md)

---

**Ready to code? Pick a task from the checklist and start! 🚀**
