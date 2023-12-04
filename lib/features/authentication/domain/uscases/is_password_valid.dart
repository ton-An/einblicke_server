/// {@template is_password_valid}
/// Checks if a given password is valid
///
/// Rules:
/// - must be between 8 and 20 characters
/// - must contain at least one uppercase letter
/// - must contain at least one lowercase letter
/// - must contain at least one number
/// - must contain at least one special character (!@#$%^&*()-_+)
///
/// Parameters:
/// - [String] password
///
/// Returns:
/// - a [bool] indicating if the password is valid
/// {@endtemplate}
class IsPasswordValid {
  /// {@macro is_password_valid}
  const IsPasswordValid();

  /// {@macro is_password_valid}
  bool call(String password) {
    final RegExp validPasswordRegex = RegExp(
      r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$%^&*()\-_+]).{8,20}$",
    );

    final bool isPasswordValid = validPasswordRegex.hasMatch(password);

    return isPasswordValid;
  }
}
