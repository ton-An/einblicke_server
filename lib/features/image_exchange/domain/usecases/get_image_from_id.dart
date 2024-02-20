import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/image_exchange/domain/models/image.dart';
import 'package:einblicke_server/features/image_exchange/domain/repositories/image_exchange_repository.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/// {@template get_image_by_id}
/// __Get Image From Id__ gets an [Image] from storage using
/// the given image id.
///
/// Properties:
/// - [String] imageId
///
/// Returns:
/// - [Image]
///
/// Failures:
/// - [StorageReadFailure]
/// {@endtemplate}
class GetImageFromId {
  /// {@macro get_image_by_id}
  const GetImageFromId({required this.imageExchangeRepository});

  /// Used for getting the image from storage
  final ImageExchangeRepository imageExchangeRepository;

  /// {@macro get_image_by_id}
  Future<Either<Failure, Image>> call({required String imageId}) {
    return imageExchangeRepository.getImageById(imageId: imageId);
  }
}
