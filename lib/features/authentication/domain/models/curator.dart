import 'package:dispatch_pi_dart/features/authentication/domain/models/picture_frame.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/user.dart';

/// {@template curator}
/// __Curator__ is a container for a user who selects/curates images and sends them
/// to a [Frame] for display.
///
/// It contains a [userId], [username], and [passwordHash]
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
