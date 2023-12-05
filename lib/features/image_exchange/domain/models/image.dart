import 'package:equatable/equatable.dart';

/// {@template image}
/// Represents an image in the application
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
