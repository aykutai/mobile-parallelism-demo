import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
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