import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/models/picture_frame.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/// {@template frame_auth_repository}
/// ___Frame Authentication Repository___ is a contract for [Frame] related
/// authentication repository operations.
/// {@endtemplate}
abstract class FrameAuthenticationRepository
    extends UserAuthenticationRepository<Frame> {
  /// {@macro frame_auth_repository}
  const FrameAuthenticationRepository();

  /// Creates a record of a frame with the given user id and curator id
  ///
  /// Parameters:
  /// - [String] userId
  /// - [String] curatorId
  ///
  /// Returns:
  /// - [Frame] object representing the user
  ///
  /// Failures:
  /// - [DatabaseWriteFailure]
  Future<Either<Failure, Frame>> createFrame({
    required String userId,
    required String ownerId,
    required String name,
  });
}
