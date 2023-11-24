/// {@template is_username_valid}
/// Checks if a given username is valid
///
/// Rules:
/// - must be between 3 and 20 characters
/// - must only contain letters, numbers, underscores, and hyphens
///
/// Returns:
/// - a [bool] indicating if the username is valid
/// {@endtemplate}
class IsUsernameValid {
  /// {@macro is_username_valid}
  const IsUsernameValid();

  /// {@macro is_username_valid}
  bool call(String username) {
    final RegExp validUsernameRegex = RegExp(r"^[a-zA-Z0-9_\-]{3,20}$");

    final bool isUsernameValid = validUsernameRegex.hasMatch(username);

    return isUsernameValid;
  }
}
