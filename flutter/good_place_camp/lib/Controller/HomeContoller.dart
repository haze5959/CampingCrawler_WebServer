import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

// Repository
import 'package:good_place_camp/Repository/SiteRepository.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';

class HomeController extends GetxController {
  SiteRepository repo = SiteRepository();

  RxList<SiteInfo> siteInfoList = <SiteInfo>[].obs;

  CalendarController calendarController = CalendarController();
  Map<DateTime, List<dynamic>> events;
  DateTime selectedDay;
  OnDaySelected onDaySelected;

  @override
  void onReady() {
    super.onReady();
    reload();
  }

  void reload() async {
    var siteInfo1 = await repo.getAllSiteInfo();
    siteInfoList.assignAll(siteInfo1.body);
    siteInfoList.refresh();
  }
}
