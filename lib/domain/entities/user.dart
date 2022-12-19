import 'package:json_annotation/json_annotation.dart';
import 'package:social_net/domain/entities/db_model.dart';

part 'user.g.dart';

@JsonSerializable()
class User implements DbModel<String> {
  @override
  final String id;
  final String nickname;
  final String? fullName;
  final DateTime? deletedAt;
  String? avatarId;

  User({
    required this.id,
    required this.nickname,
    this.fullName,
    this.deletedAt,
    this.avatarId,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromMap(Map<String, dynamic> map) => _$UserFromJson(map);
  @override
  Map<String, dynamic> toMap() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? nickname,
    String? fullName,
    DateTime? deletedAt,
    String? avatarId,
  }) {
    return User(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      fullName: fullName ?? this.fullName,
      deletedAt: deletedAt ?? this.deletedAt,
      avatarId: avatarId ?? this.avatarId,
    );
  }
}
