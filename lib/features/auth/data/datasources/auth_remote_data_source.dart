import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/supabase_client.dart';
import '../models/user_profile_model.dart';

/// Supabase ile doğrudan konuşan katman.
class AuthRemoteDataSource {
  AuthRemoteDataSource(this._client);

  final SupabaseClient _client;

  factory AuthRemoteDataSource.fromDefaultClient() =>
      AuthRemoteDataSource(supabase);

  Future<UserProfileModel> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        if (displayName != null) 'display_name': displayName,
      },
    );

    final user = response.user;
    if (user == null) {
      throw AuthException('Kullanıcı oluşturulamadı.');
    }

    // profiles tablosuna bir satır ekle (varsa upsert)
    await _client.from('profiles').upsert({
      'id': user.id,
      'email': user.email,
      if (displayName != null) 'display_name': displayName,
    });

    final profileRow = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    return UserProfileModel.fromJson(
      profileRow ??
          {
            'id': user.id,
            'email': user.email,
            'display_name': displayName,
          },
    );
  }

  Future<UserProfileModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw AuthException('Giriş başarısız.');
    }

    final profileRow = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    return UserProfileModel.fromJson(
      profileRow ??
          {
            'id': user.id,
            'email': user.email,
          },
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  Future<UserProfileModel> signInWithGoogle() async {
    // NOT: Google OAuth için Supabase dashboard'da Redirect URL ayarlamanız gerekir.
    //
    // supabase_flutter v2'de signInWithOAuth bool döner; asıl oturum değişikliği
    // authStateChanges stream'i ve currentSession üzerinden takip edilir.
    //
    // Bu metotta:
    // 1) OAuth akışını başlatıyoruz,
    // 2) onAuthStateChange üzerinden ilk signedIn event'ini bekliyoruz (timeout ile),
    // 3) Kullanıcı için profiles tablosunda kayıt upsert edip döndürüyoruz.
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: null,
    );

    // İlk signedIn event'ini, makul bir süre içinde bekle.
    final authState = await _client.auth.onAuthStateChange
        .firstWhere((event) => event.event == AuthChangeEvent.signedIn)
        .timeout(const Duration(minutes: 2), onTimeout: () {
      throw AuthException('Google ile giriş zaman aşımına uğradı.');
    });

    final session = authState.session;
    final user = session?.user;
    if (user == null) {
      throw AuthException('Google ile giriş başarısız.');
    }

    final result = await _client
        .from('profiles')
        .upsert({
          'id': user.id,
          'email': user.email,
        })
        .select();

    final data = result as List;
    final profileRow =
        data.isNotEmpty ? data.first as Map<String, dynamic> : null;

    return UserProfileModel.fromJson(
      profileRow ??
          {
            'id': user.id,
            'email': user.email,
          },
    );
  },
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Stream<UserProfileModel?> authStateChanges() async* {
    await for (final event in _client.auth.onAuthStateChange) {
      final session = event.session;
      final user = session?.user;
      if (user == null) {
        yield null;
      } else {
        final profileRow = await _client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();

        if (profileRow == null) {
          yield UserProfileModel(
            id: user.id,
            email: user.email ?? '',
          );
        } else {
          yield UserProfileModel.fromJson(profileRow);
        }
      }
    }
  }
}