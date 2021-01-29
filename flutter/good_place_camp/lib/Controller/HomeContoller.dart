import 'package:get/get.dart';
import 'dart:convert';

// Repository
import 'package:good_place_camp/Repository/SiteRepository.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';

class HomeController extends GetxController {
  SiteRepository repo = SiteRepository();

  var siteInfo;

  onInit() {
    reload();
  }

  void reload() async {
    print("sfsfs");
    siteInfo = await repo.getAllSiteInfo();
    // Map<String, dynamic> user = jsonDecode(siteInfo.body);
    print(siteInfo.body);
  }
}
