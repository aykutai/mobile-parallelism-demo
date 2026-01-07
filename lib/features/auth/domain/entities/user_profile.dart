import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// Kullanıcının sistemdeki temel profil bilgileri.
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String email,
    String? displayName,
    String? avatarUrl,
    DateTime? createdAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map&lt;String, dynamic&gt; json) =>
      _$UserProfileFromJson(json);
}