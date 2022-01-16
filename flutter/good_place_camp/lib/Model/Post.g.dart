// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: json['id'] as int,
      type: json['type'] as int,
      title: json['title'] as String?,
      body: json['body'] as String,
      nick: json['nick'] as String,
      profileUrl: json['profile_url'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      commentCount: json['comment_count'] as int,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'body': instance.body,
      'nick': instance.nick,
      'profile_url': instance.profileUrl,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'comment_count': instance.commentCount,
    };

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as int,
      postId: json['post_id'] as int,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      nick: json['nick'] as String,
      profileUrl: json['profile_url'] as String,
      comment: json['comment'] as String,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'post_id': instance.postId,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'nick': instance.nick,
      'profile_url': instance.profileUrl,
      'comment': instance.comment,
    };

Board _$BoardFromJson(Map<String, dynamic> json) => Board(
      posts: Post.fromJson(json['posts'] as Map<String, dynamic>),
      commentList: (json['commentList'] as List<dynamic>)
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BoardToJson(Board instance) => <String, dynamic>{
      'posts': instance.posts,
      'commentList': instance.commentList,
    };
