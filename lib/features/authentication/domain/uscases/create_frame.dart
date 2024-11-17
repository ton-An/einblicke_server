import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/models/picture_frame.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/frame_authentication_repository.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/generate_user_id.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/// {@template create_frame}
/// __Create Frame__ creates a user account for a [Frame].
///
/// Parameters:
/// - [String] curatorId
///
/// Returns:
/// - [Frame] if the frame was created successfully
///
/// Failures:
/// - [DatabaseReadFailure]
/// - [UserIdGenerationFailure]
/// - [DatabaseWriteFailure]
/// {@endtemplate}
class CreateFrame {
  /// {@macro create_frame}
  const CreateFrame({
    required this.frameAuthRepository,
    required this.generateUserId,
  });

  /// Used to create the record of the frame
  final FrameAuthenticationRepository frameAuthRepository;

  /// Used to generate the user id
  final GenerateUserId generateUserId;

  /// {@macro create_frame}
  Future<Either<Failure, Frame>> call(
    String curatorId,
  ) async {
    return _generateUserId(curatorId);
  }

  Future<Either<Failure, Frame>> _generateUserId(String curatorId) async {
    final Either<Failure, String> generateUserIdEither = await generateUserId();

    return generateUserIdEither.fold(Left.new, (String userId) {
      return _createFrame(userId, curatorId);
    });
  }

  Future<Either<Failure, Frame>> _createFrame(
    String userId,
    String curatorId,
  ) async {
    final Either<Failure, Frame> frameEither =
        await frameAuthRepository.createFrame(userId, curatorId);

    return frameEither.fold(Left.new, (Frame frame) {
      return Right(frame);
    });
  }
}
