import 'package:dispatch_pi_dart/features/authentication/domain/models/picture_frame.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/frame_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/check_access_token_validity/check_access_token_validity.dart';

/// {@macro check_access_token_validity_wrapper}
class CheckCuratorAccessTokenValidity extends CheckAccessTokenValidityWrapper<
    PictureFrame, FrameAuthenticationRepository> {
  /// {@macro check_access_token_validity_wrapper}
  const CheckCuratorAccessTokenValidity({
    required super.basicAuthRepository,
    required super.isTokenExpiredUseCase,
    required FrameAuthenticationRepository frameAuthenticationRepository,
  }) : super(
          userAuthenticationRepository: frameAuthenticationRepository,
        );
}
