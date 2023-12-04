import 'package:dispatch_pi_dart/features/authentication/domain/models/picture_frame.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';

/// {@template frame_auth_repository}
/// Repository for picture frame authentication
/// {@endtemplate}
abstract class FrameAuthenticationRepository
    extends UserAuthenticationRepository<PictureFrame> {
  /// {@macro frame_authentication_repository}
  const FrameAuthenticationRepository();
}
