import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';

abstract class ImageExchangeRepository {
  const ImageExchangeRepository();

  Future<Either<Failure, None>> pairCuratorXFrame({
    required String curatorId,
    required String frameId,
  });

  Future<Either<Failure, bool>> areCuratorAndFramePaired({
    required String curatorId,
    required String frameId,
  });
}
