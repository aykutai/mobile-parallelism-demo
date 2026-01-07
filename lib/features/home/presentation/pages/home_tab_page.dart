import 'package:flutter/material.dart';

/// Alt barın birinci sekmesi: Ana sayfa.
/// İçinde 2 tab'li bir TabBar var:
/// - Takip ettiklerim
/// - Keşfet
class HomeTabPage extends StatelessWidget {
  const HomeTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ana sayfa'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Takip ettiklerim'),
              Tab(text: 'Keşfet'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _FollowingFeedPlaceholder(),
            _ExploreFeedPlaceholder(),
          ],
        ),
      ),
    );
  }
}

class _FollowingFeedPlaceholder extends StatelessWidget {
  const _FollowingFeedPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Takip ettiklerinin gönderileri burada listelenecek.\n'
        'Supabase posts + user_follows ile bağlayacağız.',
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ExploreFeedPlaceholder extends StatelessWidget {
  const _ExploreFeedPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Keşfet akışı burada olacak.\n'
        'Supabase posts tablosundan global feed çekeceğiz.',
        textAlign: TextAlign.center,
      ),
    );
  }
}