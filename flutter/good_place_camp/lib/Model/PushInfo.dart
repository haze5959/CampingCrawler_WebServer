// Model
import 'package:good_place_camp/Model/CampArea.dart';

class PushInfo {
  final bool usePush;

  final List<CampArea> favoriteArea; // 토큰형식으로
  final bool useOnlyHoliday; // 주말 빈자리만 알림

  final List<String> favoriteSite; // 토큰형식으로
  final bool reservationDayPush; // 관심캠핑장만 알려줌

  PushInfo(
    this.usePush,
    this.favoriteArea,
    this.useOnlyHoliday,
    this.favoriteSite,
    this.reservationDayPush,
  );

  PushInfo.fromJson(Map<String, dynamic> json)
      : usePush = json['usePush'],
        favoriteArea = json['favoriteArea'],
        useOnlyHoliday = json['useOnlyHoliday'],
        favoriteSite = json['favoriteSite'],
        reservationDayPush = json['reservationDayPush'];

  static Map<String, PushInfo> fromJsonArr(jsonStr) {
    var pushInfoMap = Map<String, PushInfo>();
    final maps = Map<String, dynamic>.from(jsonStr);
    for (final key in maps.keys) {
      final json = Map<String, dynamic>.from(maps[key]);
      pushInfoMap[key] = PushInfo.fromJson(json);
    }

    return pushInfoMap;
  }
}
