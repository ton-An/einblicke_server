import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/models/curator.dart';
import 'package:einblicke_server/features/authentication/domain/models/picture_frame.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/frame_authentication_repository.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/generate_user_id.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/// {@template create_frame}
/// __Create Frame__ creates a user account for a [Frame].
///
/// Parameters:
/// - [String] ownerId - the id of the owner (a [Curator]) of the frame
/// - [String] name
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
  Future<Either<Failure, Frame>> call({
    required String ownerId,
    required String name,
  }) async {
    return _generateUserId(ownerId: ownerId, name: name);
  }

  Future<Either<Failure, Frame>> _generateUserId({
    required String ownerId,
    required String name,
  }) async {
    final Either<Failure, String> generateUserIdEither = await generateUserId();

    return generateUserIdEither.fold(Left.new, (String userId) {
      return _createFrame(userId: userId, ownerId: ownerId, name: name);
    });
  }

  Future<Either<Failure, Frame>> _createFrame({
    required String userId,
    required String ownerId,
    required String name,
  }) async {
    final Either<Failure, Frame> frameEither = await frameAuthRepository
        .createFrame(userId: userId, ownerId: ownerId, name: name);

    return frameEither.fold(Left.new, (Frame frame) {
      return Right(frame);
    });
  }
}
