import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/presentation/pages/sign_in_page.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/home/presentation/pages/home_page.dart';

/// TODO: .env veya güvenli yöntemle doldur:
const supabaseUrl = 'https://YOUR-PROJECT-REF.supabase.co';
const supabaseAnonKey = 'YOUR-ANON-KEY';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Social App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Auth durumuna göre içerde yönlendirme yapan SplashPage'i açıyoruz.
      home: const SplashPage(),
      routes: {
        '/auth': (_) => const SignInPage(),
        '/home': (_) => const HomePage(),
      },
    );
  }
}

