import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';

/// {@template image_save_failure}
/// Failure for when an image fails to save
/// {@endtemplate}
class ImageSaveFailure extends Failure {
  /// {@macro image_save_failure}
  const ImageSaveFailure()
      : super(
          name: "Image Save Failure",
          message: "Failed to save the image",
          categoryCode: FailureStrings.imageExchangeCategoryCode,
          code: "image_save_failure",
        );
}
