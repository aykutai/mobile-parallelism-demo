import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      home: const Scaffold(
        body: Center(
          child: Text('Clean Architecture + Supabase kurulumu hazır.'),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter\'a Geçiş'),
      ),
      body: const Center(
        child: Text(
          'Bu proje artık Flutter ile çalışıyor.\n'
          'Eski Expo / React Native kodları legacy_expo klasöründe.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}