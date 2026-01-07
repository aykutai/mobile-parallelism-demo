import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/pages/sign_in_page.dart';
import 'home_page.dart';

/// Alt bardaki 3. sekme: Profilim.
/// - Giriş yapılmamışsa: Giriş yap ekranı
/// - Giriş yapılmışsa: Profil sayfası (ProfilePage)
class ProfileTabPage extends ConsumerWidget {
  const ProfileTabPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const SignInPage();
        } else {
          return const ProfilePage();
        }
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Hata: $e')),
      ),
    );
  }
}