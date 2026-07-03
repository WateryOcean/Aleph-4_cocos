import 'dart:async';
import 'package:cocos_flutter/features/auth/providers/auth_provider.dart';
import 'package:cocos_flutter/features/chat/providers/chat_provider.dart';
import 'package:cocos_flutter/features/events/providers/event_provider.dart';
import 'package:cocos_flutter/features/product/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/storage/pref_service.dart';
import 'core/network/dio_client.dart';
import 'core/network/connectivity_service.dart';
import 'core/constants/app_colors.dart';
import 'routes/app_routes.dart';
import 'features/cart/providers/cart_provider.dart';
import 'features/orders/providers/order_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await PrefService.instance.init();
  DioClient.instance.init();
  ConnectivityService.instance.init();
  await GoogleSignIn.instance.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()..loadEvents()),
        ChangeNotifierProvider(create: (_) => ProductProvider()..loadProducts()),
        ChangeNotifierProvider(create: (_) => AuthProvider()..initializeAuth()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: const CoCosApp(),
    ),
  );
}

class CoCosApp extends StatefulWidget {
  const CoCosApp({super.key});

  @override
  State<CoCosApp> createState() => _CoCosAppState();
}

class _CoCosAppState extends State<CoCosApp> {
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();
  StreamSubscription<bool>? _connectivitySub;

  @override
  void initState() {
    super.initState();
    _connectivitySub =
        ConnectivityService.instance.connectionStream.listen((isConnected) {
      final messenger = _messengerKey.currentState;
      if (messenger == null) return;
      messenger.clearSnackBars();
      if (!isConnected) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('You are offline.'),
            duration: Duration(days: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('You are online.'),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoCos',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      scaffoldMessengerKey: _messengerKey,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
      builder: (context, child) {
        return Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (!authProvider.isInitialized) {
              return Scaffold(
                backgroundColor: AppColors.mainBackground,
                body: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF8B5CF6),
                  ),
                ),
              );
            }
            return child!;
          },
        );
      },
    );
  }
}