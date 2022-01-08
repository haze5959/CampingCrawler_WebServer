import 'package:json_annotation/json_annotation.dart';
import 'package:get/get.dart';

part 'Post.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class HomeInfo {
  final List<Post> noticeList;
  final List<Post> postsList;

  HomeInfo({
    required this.noticeList,
    required this.postsList,
  });

  factory HomeInfo.fromJson(Map<String, dynamic> json) =>
      _$HomeInfoFromJson(json);
  Map<String, dynamic> toJson() => _$HomeInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Post {
  final int? id;
  final int type;
  final String title;
  final String? body;
  final String? nick;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;
  final int? commentCount;

  Post({
    this.id,
    required this.type,
    required this.title,
    required this.body,
    this.nick,
    this.updatedAt,
    this.commentCount,
  });

  PostType getPostType() {
    switch (type) {
      case 0:
        return PostType.notice;
      case 1:
        return PostType.request;
      case 2:
        return PostType.question;
      case 3:
        return PostType.secret;
      default:
        return PostType.secret;
    }
  }

  String toPostTypeString() {
    return getPostType().toPostTypeString();
  }

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Comment {
  final int? id;
  final int postId;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;
  final String nick;
  final String comment;

  Comment(
      {this.id,
      required this.postId,
      this.updatedAt,
      required this.nick,
      required this.comment});

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}

@JsonSerializable()
class Board {
  final Post posts;
  final List<Comment> commentList;

  Board({required this.posts, required this.commentList});

  factory Board.fromJson(Map<String, dynamic> json) => _$BoardFromJson(json);
  Map<String, dynamic> toJson() => _$BoardToJson(this);
}

enum PostType {
  notice, // 공지
  request, // 캠핑장 요청
  question, // 문의
  secret, // 비밀글
}

extension PostTypeParse on PostType {
  String toPostTypeString() {
    switch (this) {
      case PostType.notice:
        return "board_notice".tr;
      case PostType.request:
        return "board_request".tr;
      case PostType.question:
        return "board_question".tr;
      case PostType.secret:
        return "board_secret".tr;
      default:
        return "board_secret".tr;
    }
  }
}
