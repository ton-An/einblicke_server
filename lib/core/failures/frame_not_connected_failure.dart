import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';

/// {@template frame_not_connected_failure}
/// Failure indicating that the frame is not connected to the server
/// {@endtemplate}
class FrameNotConnectedFailure extends Failure {
  /// {@macro frame_not_connected_failure}
  const FrameNotConnectedFailure()
      : super(
          name: "Frame Not Connected Failure",
          message: "The frame is not connected to the server",
          categoryCode: FailureStrings.imageExchangeCategoryCode,
          code: "frame_not_connected_failure",
        );
}
