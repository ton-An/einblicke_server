import 'package:einblicke_server/features/authentication/domain/models/encrypted_token.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token_bundle.g.dart';

@JsonSerializable()

/// {@template authentication_credentials}
/// __TokenBundle__ is a container for the authentication credentials of a user.
///
/// It contains an [accessToken] and a [refreshToken], both of which are
/// instances of [EncryptedToken]
/// {@endtemplate}
class ServerTokenBundle extends Equatable {
  /// {@macro authentication_credentials}
  const ServerTokenBundle({
    required this.accessToken,
    required this.refreshToken,
  });

  /// The access token for a user
  final EncryptedToken accessToken;

  /// The refresh token for a user used to generate a new access token
  final EncryptedToken refreshToken;

  /// Converts a JSON [Map] into a [ServerTokenBundle] object
  factory ServerTokenBundle.fromJson(Map<String, dynamic> json) =>
      _$TokenBundleFromJson(json);

  /// Converts a [ServerTokenBundle] object into a JSON [Map]
  Map<String, dynamic> toJson() => _$TokenBundleToJson(this);

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
