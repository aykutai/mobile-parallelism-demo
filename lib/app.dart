import 'package:flutter/material.dart';

/// Uygulama genelinde kullanılacak route isimleri.
class AppRoutes {
  static const splash = '/';
  static const auth = '/auth';
  static const home = '/home';
}

/// Temel tema / MaterialApp tanımı burada durabilir.
/// İleride go_router / auto_route gibi bir router entegre etmek istersen
/// burada merkezi olarak yönetebiliriz.
class CleanSocialApp extends StatelessWidget {
  const CleanSocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Social App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Clean Social App - Supabase ile'),
        ),
      ),
    );
  }
}