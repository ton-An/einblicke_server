import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/read_failure.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/models/image.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/repositories/image_exchange_repository.dart';

/// {@template get_image_by_id}
/// Gets an image from storage
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
