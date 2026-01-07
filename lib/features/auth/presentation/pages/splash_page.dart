import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_providers.dart';
import '../../../home/presentation/pages/root_tab_page.dart';

/// Uygulama açılışında auth durumunu bekleyip ardından ana tabbar'ı açan ekran.
/// Profil sekmesinde oturum durumuna göre giriş yap ekranı veya profil gösterilecek.
class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      // Kullanıcı oturum durumda olsun olmasın, ana tabbar'a gidelim.
      // Profil sekmesi auth durumuna göre içerik gösterecek.
      data: (_) => const RootTabPage(),
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (e, _) => Scaffold(
        body: Center(
          child: Text('Hata: $e'),
        ),
      ),
    );
  }
}