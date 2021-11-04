import 'package:json_annotation/json_annotation.dart';

part 'Post.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class HomeInfo {
  final List<Post> noticeList;
  final List<Post> postList;

  HomeInfo({
    required this.noticeList,
    required this.postList,
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
  final String body;
  final String? nick;
  final DateTime? editTime;
  final int? commentCount;

  Post({
    this.id,
    required this.type,
    required this.title,
    required this.body,
    this.nick,
    this.editTime,
    this.commentCount,
  });

  PostType getPostType() {
    return fromInt(type);
  }

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Comment {
  final int? id;
  final int postId;
  final DateTime? editTime;
  final String nick;
  final String comment;

  Comment(
      {this.id,
      required this.postId,
      this.editTime,
      required this.nick,
      required this.comment});

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Board {
  final Post post;
  final List<Comment> commentList;

  Board({required this.post, required this.commentList});

  factory Board.fromJson(Map<String, dynamic> json) => _$BoardFromJson(json);
  Map<String, dynamic> toJson() => _$BoardToJson(this);
}

enum PostType {
  notice, // 공지
  request, // 캠핑장 요청
  question, // 문의
  secret, // 비밀글
}

PostType fromInt(int val) {
  switch (val) {
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

int toInt(PostType type) {
  switch (type) {
    case PostType.notice:
      return 0;
    case PostType.request:
      return 1;
    case PostType.question:
      return 2;
    case PostType.secret:
      return 3;
    default:
      return 3;
  }
}

extension PostTypeParse on PostType {
  String toPostTypeString() {
    switch (this) {
      case PostType.notice:
        return "공지사항";
      case PostType.request:
        return "요청사항";
      case PostType.question:
        return "문의/질문";
      case PostType.secret:
        return "비밀글";
      default:
        return "비밀글";
    }
  }
}
