import 'package:flutter/material.dart';

import '../../../posts/presentation/pages/new_post_page.dart';

/// Alt barın birinci sekmesi: Ana sayfa.
/// İçinde 2 tab'li bir TabBar var:
/// - Takip ettiklerim
/// - Keşfet
/// Sağ altta bir FloatingActionButton ile yeni post ekranına gider.
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
            _FollowingFeedView(),
            _ExploreFeedPlaceholder(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const NewPostPage(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

/// Şimdilik mock veriyle, takip edilen kullanıcıların postlarını gösteren liste.
/// Supabase posts + user_follows ile bağlanacak.
class _FollowingFeedView extends StatelessWidget {
  const _FollowingFeedView();

  @override
  Widget build(BuildContext context) {
    // TODO: Buradaki dummy liste yerine Supabase'ten gelen veriyi kullanacağız.
    final posts = [
      _FeedPost(
        userFullName: 'Ahmet Yılmaz',
        username: 'ahmety',
        avatarUrl: null,
        createdAtText: '2s',
        toText: 'Herkes',
        content:
            'Bugün Supabase ile Flutter tarafında temiz mimari tasarlıyoruz. Çok keyifli gidiyor.',
        isLiked: false,
        likeCount: 12,
        commentCount: 3,
        repostCount: 1,
      ),
      _FeedPost(
        userFullName: 'Ayşe Demir',
        username: 'aysed',
        avatarUrl: null,
        createdAtText: '5s',
        toText: 'Takipçiler',
        content:
            'Nostaljik e-posta formatında bir sosyal medya post tasarımı deniyorum.',
        isLiked: true,
        likeCount: 34,
        commentCount: 10,
        repostCount: 4,
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: posts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final post = posts[index];
        return _FollowingPostCard(post: post);
      },
    );
  }
}

/// Keşfet tabı için placeholder.
/// Daha sonra Supabase posts tablosundan global/sana özel feed ile doldurulacak.
class _ExploreFeedPlaceholder extends StatelessWidget {
  const _ExploreFeedPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Keşfet akışı burada olacak.\n'
        'Supabase posts tablosundan sana özel / global feed çekeceğiz.',
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Takip ettiklerim akışındaki bir post için ViewModel benzeri basit sınıf.
class _FeedPost {
  _FeedPost({
    required this.userFullName,
    required this.username,
    required this.avatarUrl,
    required this.createdAtText,
    required this.toText,
    required this.content,
    required this.isLiked,
    required this.likeCount,
    required this.commentCount,
    required this.repostCount,
  });

  final String userFullName;
  final String username;
  final String? avatarUrl;
  final String createdAtText; // örn: "2s", "3g", "1h"
  final String toText; // To: kısmı için
  final String content;
  final bool isLiked;
  final int likeCount;
  final int commentCount;
  final int repostCount;
}

/// Nostaljik mail benzeri bir post kartı.
/// Üstte kullanıcı bilgisi + tarih,
/// altında To: satırı ve mesaj içeriği,
/// en altta beğeni / yorum / repost tuşları.
class _FollowingPostCard extends StatelessWidget {
  const _FollowingPostCard({required this.post});

  final _FeedPost post;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üst satır: avatar + ad soyad + username + sağda zaman
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage:
                      post.avatarUrl != null ? NetworkImage(post.avatarUrl!) : null,
                  child: post.avatarUrl == null
                      ? Text(
                          post.userFullName.substring(0, 1).toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userFullName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '@${post.username}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color
                              ?.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  post.createdAtText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // To: satırı
            Text(
              'To: ${post.toText}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            // Mesaj içeriği
            Text(
              post.content,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 4),
            // Alt satır: beğeni / yorum / repost tuşları
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _PostActionButton(
                  icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: post.isLiked ? Colors.red : null,
                  label: post.likeCount.toString(),
                  onPressed: () {
                    // TODO: Supabase user_likes ile like/unlike bağlanacak.
                  },
                ),
                _PostActionButton(
                  icon: Icons.mode_comment_outlined,
                  label: post.commentCount.toString(),
                  onPressed: () {
                    // TODO: Yorum ekranına geçiş eklenecek.
                  },
                ),
                _PostActionButton(
                  icon: Icons.repeat,
                  label: post.repostCount.toString(),
                  onPressed: () {
                    // TODO: Supabase user_reposts ile repost/unrepost bağlanacak.
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PostActionButton extends StatelessWidget {
  const _PostActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 18,
        color: color ?? theme.iconTheme.color,
      ),
      label: Text(
        label,
        style: theme.textTheme.bodySmall,
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}