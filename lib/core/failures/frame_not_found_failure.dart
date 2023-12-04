import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/picture_frame.dart';

/// {@template frame_not_found_failure}
/// Failure for when a [PictureFrame] could not be found.
/// {@endtemplate}
class FrameNotFoundFailure extends Failure {
  /// {@macro frame_not_found_failure}
  const FrameNotFoundFailure()
      : super(
          name: "Frame Not Found Failure",
          message: "The requested picture frame could not be found.",
          categoryCode: FailureStrings.authenticationCategoryCode,
          code: "frame_not_found_failure",
        );
}
