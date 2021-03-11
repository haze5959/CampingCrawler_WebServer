class Post {
  final PostType type;
  final String title;
  final String body;
  final String nick;
  final List<Comment> commentList;

  Post(
    this.type,
    this.title,
    this.body,
    this.nick,
    this.commentList,
  );
}

class Comment {
  final String nick;
  final String comment;

  Comment(this.nick, this.comment);
}

enum PostType {
  notice, // 공지
  request, // 캠핑장 요청
  question, // 문의
  secret, // 비밀글
}
