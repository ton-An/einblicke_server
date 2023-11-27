import 'package:dispatch_pi_dart/domain/models/picture_frame.dart';
import 'package:dispatch_pi_dart/domain/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()

/// {@template curator}
/// A [Curator] is a user who sends images to a [PictureFrame]
///
/// It includes a [userId], [username], and [passwordHash]
/// {@endtemplate}
class Curator extends User {
  /// {@macro curator}
  const Curator({
    required super.userId,
    required super.username,
    required super.passwordHash,
  });

  @override
  List<Object?> get props => [
        userId,
        username,
        passwordHash,
      ];
}
