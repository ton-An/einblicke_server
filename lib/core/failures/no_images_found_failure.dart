import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';

/// {@template no_images_found_failure}
/// Failure for when no images were found for a given frame
/// {@endtemplate}
class NoImagesFoundFailure extends Failure {
  /// {@macro no_images_found_failure}
  const NoImagesFoundFailure()
      : super(
          name: "No Images Found Failure",
          message: "No images were found for the given frame.",
          categoryCode: FailureStrings.imageExchangeCategoryCode,
          code: "no_images_found_failure",
        );
}
