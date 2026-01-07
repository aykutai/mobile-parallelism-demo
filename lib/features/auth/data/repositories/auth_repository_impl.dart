import 'package:dartz/dartz.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Either<String, UserProfile>> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final profile = await _remoteDataSource.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
      return Right(profile.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, UserProfile>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final profile = await _remoteDataSource.signInWithEmail(
        email: email,
        password: password,
      );
      return Right(profile.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _remoteDataSource.sendPasswordResetEmail(email);
      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, UserProfile>> signInWithGoogle() async {
    try {
      final profile = await _remoteDataSource.signInWithGoogle();
      return Right(profile.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<void> signOut() {
    return _remoteDataSource.signOut();
  }

  @override
  Stream<UserProfile?> authStateChanges() {
    return _remoteDataSource.authStateChanges().map(
          (model) => model?.toEntity(),
        );
  }
}