  // // 2. 공연 목록 카드에서 누른 장소의 공연장 id로 공연장 찾기

  // import 'package:front/model/performance_model.dart';


  // static Future<List<Performance>> getPerformanceInThisPlace(String id) async {
  //   try {
  //     var url = Uri.parse("${baseUrl}get_performance_in_this_place/$id");
  //     final res = await http.get(url);

  //     if (res.statusCode == 200) {
  //       var data = jsonDecode(res.body);

  //       // Check if data is not empty
  //       if (data != null) {
  //         return List<Performance>.fromJson(data);
  //       } else {
  //         return []; // 데이터가 비어있으면 null 반환
  //       }
  //     } else {
  //       return [];
  //     }
  //   } catch (e) {
  //     print("데이터를 가져오지 못했습니다: $e");
  //     return []; // 예외 발생 시 null 반환
  //   }
  // } 명화