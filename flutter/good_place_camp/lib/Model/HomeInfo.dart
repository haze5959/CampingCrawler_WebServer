import 'package:json_annotation/json_annotation.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';
import 'package:good_place_camp/Model/SiteInfo.dart';

part 'HomeInfo.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class HomeInfo {
  final List<SiteDateInfo> camps;
  final Community community;

  HomeInfo({
    required this.camps,
    required this.community,
  });

  factory HomeInfo.fromJson(Map<String, dynamic> json) =>
      _$HomeInfoFromJson(json);
  Map<String, dynamic> toJson() => _$HomeInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Community {
  final List<Post> noticeList;
  final List<Post> postsList;

  Community({
    required this.noticeList,
    required this.postsList,
  });

  factory Community.fromJson(Map<String, dynamic> json) =>
      _$CommunityFromJson(json);
  Map<String, dynamic> toJson() => _$CommunityToJson(this);
}