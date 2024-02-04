import 'package:equatable/equatable.dart';

/// {@template user}
/// __User__ is a contract for a user of the application.
///
/// It contains a [userId], an [username] and [passwordHash]
/// {@endtemplate}
abstract class User extends Equatable {
  /// {@macro user}
  const User({
    required this.userId,
    required this.username,
    required this.passwordHash,
  });

  /// [userId] is the unique identifier for the user
  final String userId;

  /// [username] is the name that the user will be known by
  final String username;

  /// [passwordHash] is the hash of the user's password
  final String passwordHash;
}
