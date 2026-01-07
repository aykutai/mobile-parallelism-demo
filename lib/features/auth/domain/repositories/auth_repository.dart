import 'package:dartz/dartz.dart';

import '../entities/user_profile.dart';

/// Auth ile ilgili domain seviyesindeki sözleşme.
abstract class AuthRepository {
  Future<Either&lt;String, UserProfile&gt;> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  });

  Future<Either&lt;String, UserProfile&gt;> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either&lt;String, Unit&gt;> sendPasswordResetEmail({
    required String email,
  });

  Future<Either&lt;String, UserProfile&gt;> signInWithGoogle();

  Future<void> signOut();

  /// Aktif kullanıcı stream'i (oturum açılmışsa profil, yoksa null).
  Stream<UserProfile?> authStateChanges();
}