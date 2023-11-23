/// {@template user}
/// Base class for all users
///
/// It includes an [username] and [passwordHash]
/// {@endtemplate}
abstract class User {
  /// {@macro user}
  const User({
    required this.username,
    required this.passwordHash,
  });

  /// [username] is the name that the user will be known by
  final String username;

  /// [passwordHash] is the hash of the user's password
  final String passwordHash;
}
