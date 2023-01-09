import 'package:json_annotation/json_annotation.dart';
import 'package:social_net/domain/entities/attach.dart';

part 'attach_model.g.dart';

@JsonSerializable()
class AttachModel {
  final String id;
  final String name;
  final String mimeType;
  final num size;

  AttachModel({
    required this.id,
    required this.name,
    required this.mimeType,
    required this.size,
  });

  factory AttachModel.fromJson(Map<String, dynamic> json) => _$AttachModelFromJson(json);
  Map<String, dynamic> toJson() => _$AttachModelToJson(this);

  factory AttachModel.fromEntity(Attach attach) => AttachModel(
        id: attach.id,
        name: attach.name,
        mimeType: attach.mimeType,
        size: attach.size,
      );
}
