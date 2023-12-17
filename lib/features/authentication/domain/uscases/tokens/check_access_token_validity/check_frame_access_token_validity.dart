import 'package:dispatch_pi_dart/features/authentication/domain/models/picture_frame.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/check_access_token_validity/check_access_token_validity.dart';

/// {@macro check_access_token_validity_wrapper}
class CheckFrameAccessTokenValidity extends CheckAccessTokenValidityWrapper<
    PictureFrame, FrameAuthenticationRepository> {
  /// {@macro check_access_token_validity_wrapper}
  const CheckFrameAccessTokenValidity({
    required super.basicAuthRepository,
    required super.isTokenExpiredUseCase,
    required super.getUserWithType,
    required FrameAuthenticationRepository frameAuthenticationRepository,
  }) : super(
          userAuthenticationRepository: frameAuthenticationRepository,
        );
}
