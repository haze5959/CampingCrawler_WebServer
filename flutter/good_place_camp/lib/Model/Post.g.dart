// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeInfo _$HomeInfoFromJson(Map<String, dynamic> json) => HomeInfo(
      noticeList: (json['notice_list'] as List<dynamic>)
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList(),
      postsList: (json['posts_list'] as List<dynamic>)
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeInfoToJson(HomeInfo instance) => <String, dynamic>{
      'notice_list': instance.noticeList,
      'posts_list': instance.postsList,
    };

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: json['id'] as int?,
      type: json['type'] as int,
      title: json['title'] as String,
      body: json['body'] as String?,
      nick: json['nick'] as String?,
      updatedTime: json['updatedTime'] == null
          ? null
          : DateTime.parse(json['updatedTime'] as String),
      commentCount: json['comment_count'] as int?,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'body': instance.body,
      'nick': instance.nick,
      'updatedTime': instance.updatedTime?.toIso8601String(),
      'comment_count': instance.commentCount,
    };

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as int?,
      postId: json['post_id'] as int,
      updatedTime: json['updatedTime'] == null
          ? null
          : DateTime.parse(json['updatedTime'] as String),
      nick: json['nick'] as String,
      comment: json['comment'] as String,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'post_id': instance.postId,
      'updatedTime': instance.updatedTime?.toIso8601String(),
      'nick': instance.nick,
      'comment': instance.comment,
    };

Board _$BoardFromJson(Map<String, dynamic> json) => Board(
      post: Post.fromJson(json['post'] as Map<String, dynamic>),
      commentList: (json['comment_list'] as List<dynamic>)
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BoardToJson(Board instance) => <String, dynamic>{
      'post': instance.post,
      'comment_list': instance.commentList,
    };
