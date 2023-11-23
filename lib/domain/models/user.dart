/// {@template user}
/// Base class for all users
///
/// It includes an [id], [username], and [passwordHash]
/// {@endtemplate}
abstract class User {
  /// {@macro user}
  const User({
    required this.id,
    required this.username,
    required this.passwordHash,
  });

  /// [id] is the unique identifier for the user
  final String id;

  /// [username] is the name that the user will be known by
  final String username;

  /// [passwordHash] is the hash of the user's password
  final String passwordHash;
}
