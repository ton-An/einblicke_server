import 'package:einblicke_server/features/authentication/domain/models/curator.dart';
import 'package:einblicke_server/features/authentication/domain/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()

/// {@template frame}
/// __Frame__ is a container for a picture frame that displays images selected/curated by a [Curator].
///
/// It contains a [userId], [username], and [passwordHash]
/// {@endtemplate}
class Frame extends User {
  /// {@macro frame}
  const Frame({
    required super.userId,
    required this.ownerId,
    required this.name,
  });

  /// The id of the [Curator] that owns this frame.
  final String ownerId;

  /// The name of the frame given by the owner/[Curator].
  final String name;

  @override
  List<Object?> get props => [
        userId,
        ownerId,
        name,
      ];
}
