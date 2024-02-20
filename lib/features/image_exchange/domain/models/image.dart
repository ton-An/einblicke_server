import 'package:einblicke_server/features/authentication/domain/models/picture_frame.dart';
import 'package:equatable/equatable.dart';

/// {@template image}
/// __Image__ is a container for an image that is sent to a [Frame] for display.
///
/// It contains an [imageId] and [imageBytes]
/// {@endtemplate}
class Image extends Equatable {
  /// {@macro image}
  const Image({
    required this.imageId,
    required this.imageBytes,
  });

  /// The id of the image
  final String imageId;

  /// The bytes of the image
  final List<int> imageBytes;

  @override
  List<Object?> get props => [
        imageId,
        imageBytes,
      ];
}
