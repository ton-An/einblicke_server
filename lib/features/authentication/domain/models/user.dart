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
  });

  /// [userId] is the unique identifier for the user
  final String userId;
}
