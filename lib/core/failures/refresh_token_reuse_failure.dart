import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';

/// {@template refresh_token_reuse_failure}
/// Failure for when the refresh token has already been used.
///
/// This could be a sign of a security breach.
/// {@endtemplate}
class RefreshTokenReuseFailure extends Failure {
  /// {@macro refresh_token_reuse_failure}
  const RefreshTokenReuseFailure()
      : super(
          name: "Refresh Token Reuse Failure",
          message: """
The token for refreshing the credentials from the server has already been used.
All current sessions have been invalidated.  
Please log in again and report this to the server.
""",
          categoryCode: FailureStrings.authenticationCategoryCode,
          code: "refresh_token_reuse_failure",
        );
}
