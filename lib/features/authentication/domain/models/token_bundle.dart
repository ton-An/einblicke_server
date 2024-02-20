import 'package:einblicke_server/features/authentication/domain/models/encrypted_token.dart';
import 'package:equatable/equatable.dart';

/// {@template authentication_credentials}
/// __TokenBundle__ is a container for the authentication credentials of a user.
///
/// It contains an [accessToken] and a [refreshToken], both of which are
/// instances of [EncryptedToken]
/// {@endtemplate}
class TokenBundle extends Equatable {
  /// {@macro authentication_credentials}
  const TokenBundle({
    required this.accessToken,
    required this.refreshToken,
  });

  /// The access token for a user
  final EncryptedToken accessToken;

  /// The refresh token for a user used to generate a new access token
  final EncryptedToken refreshToken;

  /// Converts this instance to a json [Map]
  Map<String, dynamic> toJson() => {
        'access_token': accessToken.token,
        'refresh_token': refreshToken.token,
      };

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
