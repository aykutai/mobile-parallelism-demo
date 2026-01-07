import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

/// Kullanıcının profil ekranı.
/// Üst kısımda avatar + istatistikler, altında tabbar ile farklı post listeleri.
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

        // Şimdilik statik / mock değerler, ileride Supabase'den gelecek:
        const totalLikes = 128; // kullanıcının postlarına gelen toplam beğeni
        const totalPosts = 24; // post sayısı
        const followers = 340; // takipçi
        const following = 180; // takip

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Profil'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await repo.signOut();
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundImage: user.avatarUrl != null
                            ? NetworkImage(user.avatarUrl!)
                            : null,
                        child: user.avatarUrl == null
                            ? Text(
                                (user.displayName ?? user.email)
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.displayName ?? 'İsimsiz kullanıcı',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _ProfileStat(
                                  label: 'Beğeni',
                                  value: totalLikes,
                                ),
                                _ProfileStat(
                                  label: 'Post',
                                  value: totalPosts,
                                ),
                                _ProfileStat(
                                  label: 'Takipçi',
                                  value: followers,
                                ),
                                _ProfileStat(
                                  label: 'Takip',
                                  value: following,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                const TabBar(
                  labelColor: Colors.black,
                  tabs: [
                    Tab(icon: Icon(Icons.article_outlined), text: 'Postlarım'),
                    Tab(icon: Icon(Icons.repeat), text: 'Repost'),
                    Tab(icon: Icon(Icons.favorite_border), text: 'Beğendiğim'),
                  ],
                ),
                const Divider(height: 1),
                Expanded(
                  child: TabBarView(
                    children: [
                      // 1) Kendi Postları
                      _ProfilePostsList(
                        emptyText:
                            'Henüz kendi gönderin yok.\nİlk gönderini paylaşmak için post ekranını bağlayacağız.',
                      ),
                      // 2) Yeniden paylaştıkları (reposts)
                      _ProfilePostsList(
                        emptyText:
                            'Henüz yeniden paylaştığın bir gönderi yok.\nRepost sistemi eklendiğinde burada görünecek.',
                      ),
                      // 3) Beğendikleri / yorum yaptıkları
                      _ProfilePostsList(
                        emptyText:
                            'Henüz beğendiğin veya yorum yaptığın gönderi yok.\nBeğeniler ve yorumlar Supabase’e bağlanacak.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
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

/// Üst kısımdaki özet istatistik bileşeni.
class _ProfileStat extends StatelessWidget {
  const _ProfileStat({
    required this.label,
    required this.value,
  });

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

/// TabBar altında listeler için placeholder widget.
/// İleride Supabase'den gelen gerçek postlar ile dolduracağız.
class _ProfilePostsList extends StatelessWidget {
  const _ProfilePostsList({required this.emptyText});

  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Text(
            emptyText,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}