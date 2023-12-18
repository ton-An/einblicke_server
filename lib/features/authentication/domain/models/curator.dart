import 'package:dispatch_pi_dart/features/authentication/domain/models/picture_frame.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/user.dart';

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
