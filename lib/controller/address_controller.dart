import 'package:camera_pj/component/token_manager.dart';
import 'package:camera_pj/controller/account_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  var placeName = ''.obs;
  var placeAddress = ''.obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var placeNickname = ''.obs;




  void updatePlace(String name, String address, double lat, double lng) {
    placeName.value = name;
    placeAddress.value = address;
    latitude.value = lat;
    longitude.value = lng;
    update();
  }

  void savePlace(String nickname, String coordinates,String address,String category) async {
    // TODO: 여기에 실제 저장 로직 구현
    print(address);
    print(coordinates);
    print(category);
    final dio = Dio(BaseOptions(
      followRedirects: true,
      maxRedirects: 5, // 최대 리디렉션 횟수
    ));
    final String? idToken = await TokenManager().getToken();
    try {
      dio.interceptors.add(CustomInterceptor());

      final response = await dio.post(
          'http://pengy.dev/api/spaces/myspace/',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $idToken',
          }),
          data:{
            "category": "Cafe",
            "spaceName": "cafe",
            "coordinates": "126.9996417, 37.56100278",
            "address": "서울시 동작구 상도동",
          }
      );
      if (response.statusCode == 200) {
        print('장소등록 성공: ${response.data}');
      } else {
        print('장소등록 실패: ${response.data}');
      }
    } catch (e) {
      print('장소등록 요청 중 오류 발생: $e');
    }

  }
}