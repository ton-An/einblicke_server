import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paired_frame_info.g.dart';

@JsonSerializable()

/// {@template paired_frame_info}
/// __PairedFrameInfo__ contains the basic of a frame paired to a curator.
/// {@endtemplate}
class PairedFrameInfo extends Equatable {
  /// {@macro paired_frame_info}
  const PairedFrameInfo({
    required this.id,
    required this.name,
  });

  /// The unique identifier of the frame
  final String id;

  /// The name of the frame
  final String name;

  /// Converts a JSON [Map] to a [PairedFrameInfo]
  factory PairedFrameInfo.fromJson(Map<String, dynamic> json) =>
      _$PairedFrameInfoFromJson(json);

  /// Converts a [PairedFrameInfo] to a JSON [Map]
  Map<String, dynamic> toJson() => _$PairedFrameInfoToJson(this);

  @override
  List<Object?> get props => [id, name];
}
