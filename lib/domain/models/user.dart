import 'package:equatable/equatable.dart';

/// {@template user}
/// Base class for all users
///
/// It includes an [username] and [passwordHash]
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
