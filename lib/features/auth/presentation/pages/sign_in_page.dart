import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/auth_repository.dart';
import '../providers/auth_providers.dart';
import 'sign_up_page.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<void> _signInWithEmail() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await _repo.signInWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    result.fold(
      (l) => setState(() => _error = l),
      (r) => Navigator.of(context).pushReplacementNamed('/home'),
    );

    setState(() {
      _loading = false;
    });
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await _repo.signInWithGoogle();

    result.fold(
      (l) => setState(() => _error = l),
      (r) => Navigator.of(context).pushReplacementNamed('/home'),
    );

    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const SignUpPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Clean Social App',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Şifre',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_error != null)
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: _loading ? null : _signInWithEmail,
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Giriş yap'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _loading ? null : _signInWithGoogle,
                    icon: const Icon(Icons.login),
                    label: const Text('Google ile devam et'),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: _loading ? null : _goToSignUp,
                    child: const Text('Hesabın yok mu? Kayıt ol'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}