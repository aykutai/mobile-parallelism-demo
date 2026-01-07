import 'package:flutter/material.dart';

/// Alt bardaki 2. sekme: yeni post oluşturma ekranı.
/// Şimdilik sadece basit bir text alanı ve gönder butonu var.
/// Supabase entegrasyonunu ilerleyen adımda ekleyeceğiz.
class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key});

  @override
  State&lt;NewPostPage> createState() =&gt; _NewPostPageState();
}

class _NewPostPageState extends State&lt;NewPostPage> {
  final _controller = TextEditingController();
  bool _submitting = false;
  String? _error;

  Future&lt;void> _submit() async {
    // TODO: Supabase posts tablosuna insert eklenecek.
    setState(() {
      _submitting = true;
      _error = null;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _submitting = false;
      _controller.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post taslak olarak kaydedildi (mock).')),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              minLines: 3,
              decoration: const InputDecoration(
                hintText: 'Ne düşünüyorsun?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            if (_error != null)
              Text(
                _error!,
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
              ),
            const Spacer(),
            FilledButton.icon(
              onPressed: _submitting ? null : _submit,
              icon: _submitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              label: const Text('Paylaş'),
            ),
          ],
        ),
      ),
    );
  }
}