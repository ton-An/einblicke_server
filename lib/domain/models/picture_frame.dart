import 'package:dispatch_pi_dart/domain/models/curator.dart';
import 'package:dispatch_pi_dart/domain/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()

/// {@template pictureFrame}
/// A [PictureFrame] is a frame that displays images sent by [Curator]s
///
/// It includes a [userId], [username], and [passwordHash]
/// {@endtemplate}
class PictureFrame extends User {
  /// {@macro pictureFrame}
  const PictureFrame({
    required super.userId,
    required super.username,
    required super.passwordHash,
  });

  @override
  List<Object?> get props => [
        userId,
        username,
        passwordHash,
      ];
}
