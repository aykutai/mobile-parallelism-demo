import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
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
    try {
      // 1. Google tarafında oturum aç
      // TODO: Web ve iOS için kendi client ID'lerini buraya koymalısın.
      const webClientId = 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';
      const iosClientId = 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com';

      final googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );

      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final accessToken = googleAuth?.accessToken;
      final idToken = googleAuth?.idToken;

      if (idToken == null) {
        throw const AuthException('Google ID Token alınamadı.');
      }

      // 2. Bu token ile Supabase'e giriş yap
      final response = await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final user = response.user;
      if (user == null) {
        throw const AuthException('Kullanıcı bulunamadı.');
      }

      // 3. Profil verisini güncelle/al
    final result = await _client
        .from('profiles')
        .upsert({
          'id': user.id,
          'email': user.email,
          'display_name': user.userMetadata?['full_name'],
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
  } catch (e) {
    throw AuthException('Google Login Hatası: $e');
 _code }new
</}
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