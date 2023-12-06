import 'package:dispatch_pi_dart/features/authentication/domain/models/encrypted_token.dart';
import 'package:equatable/equatable.dart';

/// {@template authentication_credentials}
/// A model for storing the authentication credentials of a user
///
/// It includes an [accessToken] and a [refreshToken]
/// {@endtemplate}
class AuthenticationCredentials extends Equatable {
  /// {@macro authentication_credentials}
  const AuthenticationCredentials({
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
