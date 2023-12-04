import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/curator.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/picture_frame.dart';

/// {@template curator_x_frame_already_paired_failure}
/// Failure for when a [Curator] and [PictureFrame] are already paired.
/// {@endtemplate}
class CuratorXFrameAlreadyPairedFailure extends Failure {
  /// {@macro curator_x_frame_already_paired_failure}
  const CuratorXFrameAlreadyPairedFailure()
      : super(
          name: "Curator And Frame Already Paired Failure",
          message: "The curator and frame are already paired.",
          categoryCode: FailureStrings.imageExchangeCategoryCode,
          code: "curator_x_frame_already_paired_failure",
        );
}
