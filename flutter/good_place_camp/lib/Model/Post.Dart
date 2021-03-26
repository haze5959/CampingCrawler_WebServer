class Post {
  final int id;
  final PostType type;
  final String title;
  final String body;
  final String nick;
  final DateTime editTime;
  final int commentCount;

  Post(
    this.id,
    this.type,
    this.title,
    this.body,
    this.nick,
    this.editTime,
    this.commentCount,
  );

  Post._fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        type = fromInt(json['type'] as int),
        title = json['title'],
        body = json['body'],
        nick = json['nick'],
        editTime =
            DateTime.parse(json['edit_time']), // '1974-03-20 00:00:00.000'
        commentCount = json['comment_count'];

  static List<Post> fromJsonArr(jsonStr) {
    final list = List<Map<String, dynamic>>.from(jsonStr);
    final listPostInfo = list.map((json) => Post._fromJson(json));
    return listPostInfo.toList();
  }

  static Post fromJson(jsonStr) {
    final map = Map<String, dynamic>.from(jsonStr);
    return Post._fromJson(map);
  }

  static Map<String, List<Post>> fromJsonToHomePosts(jsonStr) {
    final map = Map<String, dynamic>.from(jsonStr);
    final homePosts = {
      "notice": Post.fromJsonArr(map['notice']),
      "posts": Post.fromJsonArr(map['posts'])
    };
    return homePosts;
  }
}

class Comment {
  final int id;
  final int postId;
  final DateTime editTime;
  final String nick;
  final String comment;

  Comment(this.id, this.postId, this.editTime, this.nick, this.comment);

  Comment._fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        postId = json['post_id'] as int,
        editTime = DateTime.parse(json['edit_time']),
        nick = json['nick'],
        comment = json['comment'];

  static List<Comment> fromJsonArr(jsonStr) {
    final list = List<Map<String, dynamic>>.from(jsonStr);
    final listCommentInfo = list.map((json) => Comment._fromJson(json));
    return listCommentInfo.toList();
  }

  static Comment fromJson(jsonStr) {
    final map = Map<String, dynamic>.from(jsonStr);
    return Comment._fromJson(map);
  }
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

extension ParseToString on PostType {
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
    }
  }
}

class Board {
  final Post post;
  final List<Comment> commentList;

  Board(this.post, this.commentList);

  Board._fromJson(Map<String, dynamic> json)
      : post = json['posts'] != null ? Post.fromJson(json['posts']) : null,
        commentList = json['comments'] != null
            ? Comment.fromJsonArr(json['comments'])
            : null;

  static Board fromJson(jsonStr) {
    final map = Map<String, dynamic>.from(jsonStr);
    return Board._fromJson(map);
  }
}
