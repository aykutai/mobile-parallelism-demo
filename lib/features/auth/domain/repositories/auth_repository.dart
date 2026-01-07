import 'package:dartz/dartz.dart';

import '../entities/user_profile.dart';

/// Auth ile ilgili domain seviyesindeki sözleşme.
abstract class AuthRepository {
  Future<Either<String, UserProfile>> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  });

  Future<Either<String, UserProfile>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<String, Unit>> sendPasswordResetEmail({
    required String email,
  });

  Future<Either<String, UserProfile>> signInWithGoogle();

  Future<void> signOut();

  /// Aktif kullanıcı stream'i (oturum açılmışsa profil, yoksa null).
  Stream<UserProfile?> authStateChanges();
}