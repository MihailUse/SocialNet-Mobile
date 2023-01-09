import 'package:json_annotation/json_annotation.dart';
import 'package:social_net/data/models/attach_model.dart';

part 'search_list_user_model.g.dart';

@JsonSerializable()
class SearchListUserModel {
  final String id;
  final String nickname;
  final int followerCount;
  final String? fullName;
  final AttachModel? avatar;

  SearchListUserModel({
    required this.id,
    required this.nickname,
    required this.followerCount,
    this.fullName,
    this.avatar,
  });

  factory SearchListUserModel.fromJson(Map<String, dynamic> json) => _$SearchListUserModelFromJson(json);
  Map<String, dynamic> toJson() => _$SearchListUserModelToJson(this);
}
