import 'package:camera_pj/component/token_manager.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class SpaceDetail {
  final int id;
  final int mySpace;
  final int fireHazard;
  final String thumbnailImage;
  final String nickname;

  SpaceDetail({
    required this.id,
    required this.mySpace,
    required this.fireHazard,
    required this.thumbnailImage,
    required this.nickname,
  });

  factory SpaceDetail.fromJson(Map<String, dynamic> json) {
    return SpaceDetail(
      id: json['id'],
      mySpace: json['my_space'],
      fireHazard: json['fire_hazard'],
      thumbnailImage: json['thumbnail_image'],
      nickname: json['nickname'],
    );
  }
}

class SpaceObjectController extends GetxController {


  List<SpaceDetail> spaceDetails = <SpaceDetail>[].obs;

  @override
  void onInit() {
    super.onInit();
  }
  final Dio dio = Dio();

  Future<List<SpaceDetail>> fetchSpaceObjects(int spaceId) async {
    try {
      final String? idToken = await TokenManager().getToken();
      final response = await dio.get('https://pengy.dev/api/spaces/myspace/$spaceId/',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        }),);
      if (response.statusCode == 200) {
        print("11:${response.data}");
        var fetchedObjects = List<SpaceDetail>.from(response.data.map((json) => SpaceDetail.fromJson(json)));
        spaceDetails = fetchedObjects;
        print(spaceDetails);
      } else {
        print('Failed to load space objects');
      }
      return spaceDetails;
    } catch (e) {
      print(e.toString());
    }
    return spaceDetails;
  }

}
