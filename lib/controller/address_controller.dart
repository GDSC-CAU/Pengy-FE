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
  void savePlace(String nickname) {
    // TODO: 여기에 실제 저장 로직 구현
    print(nickname);
  }
}