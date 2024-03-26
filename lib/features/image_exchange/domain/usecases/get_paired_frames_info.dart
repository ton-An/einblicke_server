import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/models/picture_frame.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:einblicke_server/features/image_exchange/domain/repositories/image_exchange_repository.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/* To-Do:
  - [ ] Make naming consistent and clear
  - [ ] Find alternative for returning a [UserNotFoundFailure]
*/

/// {@template get_paired_frames_info}
/// __GetPairedFramesInfo__ gets the information of frames paired with a curator.
///
/// Parameters:
/// - [String] curatorId
///
/// Returns:
/// - [List<PairedFrameInfo>]
///
/// Failures:
/// - [DatabaseReadFailure]
/// - [UserNotFoundFailure]
/// {@endtemplate}
class GetPairedFramesInfo {
  /// {@macro get_paired_frames_info}
  const GetPairedFramesInfo({
    required this.imageExchangeRepository,
    required this.frameAuthRepository,
  });

  /// Gets the paired frames
  final ImageExchangeRepository imageExchangeRepository;

  /// Gets the names of the paired frames
  final FrameAuthenticationRepository frameAuthRepository;

  /// {@macro get_paired_frames_info}
  Future<Either<Failure, List<PairedFrameInfo>>> call({
    required String curatorId,
  }) async {
    return _getPairedFramesIds(curatorId);
  }

  Future<Either<Failure, List<PairedFrameInfo>>> _getPairedFramesIds(
      String curatorId) async {
    final Either<Failure, List<String>> pairedFrameIdsEither =
        await imageExchangeRepository.getPairedFrameIdsOfCurator(
      curatorId: curatorId,
    );

    return pairedFrameIdsEither.fold(Left.new, _getPairedFramesInfo);
  }

  Future<Either<Failure, List<PairedFrameInfo>>> _getPairedFramesInfo(
    List<String> pairedFrameIds, [
    List<PairedFrameInfo> frameInfoList = const [],
    int i = 0,
  ]) async {
    if (i == pairedFrameIds.length) {
      return Right(frameInfoList);
    }

    final Either<Failure, Frame> frameInfoEither =
        await frameAuthRepository.getUserFromId(
      pairedFrameIds[i],
    );

    return frameInfoEither.fold(
      Left.new,
      (Frame frame) {
        final PairedFrameInfo frameInfo = PairedFrameInfo(
          id: frame.userId,
          name: frame.username,
        );

        final List<PairedFrameInfo> newFrameInfoList = List.from(frameInfoList)
          ..add(frameInfo);

        return _getPairedFramesInfo(
          pairedFrameIds,
          newFrameInfoList,
          i + 1,
        );
      },
    );
  }
}
