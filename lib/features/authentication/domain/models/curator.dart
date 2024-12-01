import 'package:einblicke_server/features/authentication/domain/models/picture_frame.dart';
import 'package:einblicke_server/features/authentication/domain/models/user.dart';

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
    required this.username,
    required this.passwordHash,
  });

  /// [username] is the name that the user will be known by
  final String username;

  /// [passwordHash] is the hash of the user's password
  final String passwordHash;

  @override
  List<Object?> get props => [
        userId,
        username,
        passwordHash,
      ];
}
