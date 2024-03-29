import 'package:json_annotation/json_annotation.dart';
import 'package:social_net/data/models/attach_model.dart';
import 'package:social_net/domain/entities/db_model.dart';

part 'attach.g.dart';

@JsonSerializable()
class Attach implements DbModel<String> {
  @override
  final String id;
  final String link;
  final String name;
  final String mimeType;
  final int size;
  final String? postId;

  Attach({
    required this.id,
    required this.link,
    required this.name,
    required this.mimeType,
    required this.size,
    this.postId,
  });

  factory Attach.fromJson(Map<String, dynamic> json) => _$AttachFromJson(json);
  Map<String, dynamic> toJson() => _$AttachToJson(this);

  factory Attach.fromMap(Map<String, dynamic> map) => _$AttachFromJson(map);
  @override
  Map<String, dynamic> toMap() => _$AttachToJson(this);

  factory Attach.fromModel(AttachModel attach, [String? postId]) => Attach(
        id: attach.id,
        link: attach.link ?? "",
        name: attach.name,
        mimeType: attach.mimeType,
        size: attach.size,
        postId: postId,
      );

  Attach copyWith({
    String? id,
    String? link,
    String? name,
    String? mimeType,
    int? size,
    String? postId,
  }) {
    return Attach(
      id: id ?? this.id,
      link: link ?? this.link,
      name: name ?? this.name,
      mimeType: mimeType ?? this.mimeType,
      size: size ?? this.size,
      postId: postId ?? this.postId,
    );
  }
}
