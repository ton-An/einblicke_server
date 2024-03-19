import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'encrypted_token.g.dart';

@JsonSerializable()

/// {@template encrypted_token}
/// __EncryptedToken__ is a container for an encrypted token which used for
/// authentication.
///
/// It contains the [token] string and the [expiresAt] time of the token.
/// {@endtemplate}
class EncryptedToken extends Equatable {
  /// {@macro encrypted_token}
  const EncryptedToken({
    required this.token,
    required this.expiresAt,
  });

  /// Is the token string used for authentication
  final String token;

  /// Is the time in seconds that the token will be valid for
  final DateTime expiresAt;

  /// Converts a JSON [Map] into a [EncryptedToken] object
  factory EncryptedToken.fromJson(Map<String, dynamic> json) =>
      _$EncryptedTokenFromJson(json);

  /// Converts a [EncryptedToken] object into a JSON [Map]
  Map<String, dynamic> toJson() => _$EncryptedTokenToJson(this);

  @override
  List<Object?> get props => [
        token,
        expiresAt,
      ];
}
