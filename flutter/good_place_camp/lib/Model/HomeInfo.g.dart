// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HomeInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeInfo _$HomeInfoFromJson(Map<String, dynamic> json) => HomeInfo(
      camps: (json['camps'] as List<dynamic>)
          .map((e) => SiteDateInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      community: Community.fromJson(json['community'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HomeInfoToJson(HomeInfo instance) => <String, dynamic>{
      'camps': instance.camps,
      'community': instance.community,
    };

Community _$CommunityFromJson(Map<String, dynamic> json) => Community(
      noticeList: (json['notice_list'] as List<dynamic>)
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList(),
      postsList: (json['posts_list'] as List<dynamic>)
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommunityToJson(Community instance) => <String, dynamic>{
      'notice_list': instance.noticeList,
      'posts_list': instance.postsList,
    };
