import 'package:einblicke_server/features/authentication/domain/models/curator.dart';
import 'package:einblicke_server/features/authentication/domain/models/picture_frame.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()

/// {@template token_payload}
/// __TokenClaims__ is a contract for the claims of a JWE token.
///
/// It contains the [userId] of the user, the [userType] of the user,
/// the [issuedAt] time of the token, and the [expiresAt] time of the token.
/// {@endtemplate}
abstract class TokenClaims extends Equatable {
  /// {@macro token_payload}
  const TokenClaims({
    required this.userId,
    required this.userType,
    required this.issuedAt,
    required this.expiresAt,
  });

  /// The id of the user this payload belongs to
  final String userId;

  @JsonKey(fromJson: userTypesFromJson, toJson: userTypesToJson)

  /// The type of user this payload belongs to
  final Type userType;

  /// The time this token was issued at
  final DateTime issuedAt;

  /// The time this token expires at
  final DateTime expiresAt;

  static String userTypesToJson(Type type) => type.toString();
  static Type userTypesFromJson(String type) {
    switch (type) {
      case 'Curator':
        return Curator;
      case 'PictureFrame':
        return Frame;
      default:
        throw Exception('Unknown type: $type');
    }
  }
}
