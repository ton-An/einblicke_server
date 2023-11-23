import 'package:dispatch_pi_dart/domain/models/curator.dart';
import 'package:dispatch_pi_dart/domain/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()

/// {@template pictureFrame}
/// A [PictureFrame] is a frame that displays images sent by [Curator]s
///
/// It includes a [pictureFrameId], [username], and [passwordHash]
/// {@endtemplate}
class PictureFrame extends User {
  /// {@macro pictureFrame}
  PictureFrame({
    required this.pictureFrameId,
    required super.username,
    required super.passwordHash,
  });

  /// [pictureFrameId] is the unique identifier for the picture frame
  final String pictureFrameId;
}
