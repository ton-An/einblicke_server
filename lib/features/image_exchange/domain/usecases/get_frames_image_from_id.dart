import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/models/image.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/repositories/image_exchange_repository.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/usecases/get_image_from_id.dart';

// ToDo: test
class GetFramesImageFromId {
  final GetImageFromId getImageFromId;

  final ImageExchangeRepository imageExchangeRepository;

  const GetFramesImageFromId({
    required this.getImageFromId,
    required this.imageExchangeRepository,
  });

  Future<Either<Failure, Image>> call({
    required String frameId,
    required String imageId,
  }) async {
    return _checkIfImageBelongsToFrame(frameId: frameId, imageId: imageId);
  }

  Future<Either<Failure, Image>> _checkIfImageBelongsToFrame({
    required String frameId,
    required String imageId,
  }) async {
    final Either<Failure, bool> doesImageBelongToFrame =
        await imageExchangeRepository.doesImageBelongToFrame(
      frameId: frameId,
      imageId: imageId,
    );

    return doesImageBelongToFrame.fold(
      Left.new,
      (bool doesImageBelongToFrame) {
        return _getImage(imageId: imageId);
      },
    );
  }

  Future<Either<Failure, Image>> _getImage({required String imageId}) async {
    final imageEither = await getImageFromId(imageId: imageId);

    return imageEither;
  }
}
