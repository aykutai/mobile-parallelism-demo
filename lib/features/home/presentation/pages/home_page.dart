import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

/// Şimdilik basit bir feed + profil bilgisi gösteren ana ekran.
/// Post'lar sadece text olacak, kullanıcıların avatarUrl alanı ileride doldurulacak.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final repo = ref.watch(authRepositoryProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          // Normalde SplashPage zaten buna izin vermez ama güvenlik için:
          return const Scaffold(
            body: Center(child: Text('Oturum bulunamadı')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Clean Social App'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await repo.signOut();
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage:
                        user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                    child: user.avatarUrl == null
                        ? Text(
                            (user.displayName ?? user.email)
                                .substring(0, 1)
                                .toUpperCase(),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName ?? 'İsimsiz kullanıcı',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Feed (yakında):',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Buraya Supabase posts tablosundan gelen sadece text içerikli gönderiler gelecek.\n'
                'Her gönderi, kullanıcı profil fotoğrafı (avatarUrl) ile birlikte gösterilecek.',
              ),
            ],
          ),
        );
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