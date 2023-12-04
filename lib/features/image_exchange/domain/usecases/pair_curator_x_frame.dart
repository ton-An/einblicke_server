import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/already_paired_failure.dart';
import 'package:dispatch_pi_dart/core/failures/curator_not_found_failure.dart';
import 'package:dispatch_pi_dart/core/failures/database_read_failure.dart';
import 'package:dispatch_pi_dart/core/failures/database_write_failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/frame_not_found_failure.dart';
import 'package:dispatch_pi_dart/core/failures/user_not_found_failure.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/curator.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/picture_frame.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/curator_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/frame_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/repositories/image_exchange_repository.dart';

/// {@template pair_curator_x_frame}
/// Pairs a [Curator] with a [PictureFrame]
///
/// Parameters:
/// - [String] curatorId
/// - [String] frameId
///
/// Failiures:
/// - [UserNotFoundFailure]
/// - [AlreadyPairedFailure]
/// - [DatabaseReadFailure]
/// - [DatabaseWriteFailure]
/// {@endtemplate}
class PairCuratorXFrame {
  /// {@macro pair_curator_x_frame}
  const PairCuratorXFrame({
    required this.imageExchangeRepository,
    required this.curatorAuthenticationRepository,
    required this.frameAuthenticationRepository,
  });

  /// Used to pair the curator with the frame
  final ImageExchangeRepository imageExchangeRepository;

  /// Used to check if the curator exists
  final CuratorAuthenticationRepository curatorAuthenticationRepository;

  /// Used to check if the frame exists
  final FrameAuthenticationRepository frameAuthenticationRepository;

  /// {@macro pair_curator_x_frame}
  Future<Either<Failure, None>> call({
    required String curatorId,
    required String frameId,
  }) async {
    return _checkIfCuratorExists(
      curatorId: curatorId,
      frameId: frameId,
    );
  }

  Future<Either<Failure, None>> _checkIfCuratorExists({
    required String curatorId,
    required String frameId,
  }) async {
    final Either<Failure, bool> doesCuratorExistEither =
        await curatorAuthenticationRepository.doesUserWithIdExist(curatorId);

    return doesCuratorExistEither.fold(Left.new, (bool doesCuratorExist) {
      if (!doesCuratorExist) {
        return const Left(CuratorNotFoundFailure());
      }

      return _checkIfFrameExists(
        curatorId: curatorId,
        frameId: frameId,
      );
    });
  }

  Future<Either<Failure, None>> _checkIfFrameExists({
    required String curatorId,
    required String frameId,
  }) async {
    final Either<Failure, bool> doesFrameExistEither =
        await frameAuthenticationRepository.doesUserWithIdExist(frameId);

    return doesFrameExistEither.fold(Left.new, (bool doesFrameExist) {
      if (!doesFrameExist) {
        return const Left(FrameNotFoundFailure());
      }

      return _checkIfCuratorXFrameAlreadyPaired(
        curatorId: curatorId,
        frameId: frameId,
      );
    });
  }

  Future<Either<Failure, None>> _checkIfCuratorXFrameAlreadyPaired({
    required String curatorId,
    required String frameId,
  }) async {
    final Either<Failure, bool> areCuratorXFrameAlreadyPairedEither =
        await imageExchangeRepository.areCuratorAndFramePaired(
      curatorId: curatorId,
      frameId: frameId,
    );

    return areCuratorXFrameAlreadyPairedEither.fold(Left.new,
        (bool areCuratorXFrameAlreadyPaired) {
      if (areCuratorXFrameAlreadyPaired) {
        return const Left(AlreadyPairedFailure());
      }

      return _pairCuratorXFrame(
        curatorId: curatorId,
        frameId: frameId,
      );
    });
  }

  Future<Either<Failure, None>> _pairCuratorXFrame({
    required String curatorId,
    required String frameId,
  }) {
    return imageExchangeRepository.pairCuratorXFrame(
      curatorId: curatorId,
      frameId: frameId,
    );
  }
}
