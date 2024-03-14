// // // // // 이거 id로 받아서 API로 넘기자
// // // // // 그래야 공연 페이지에서도 넘어오고
// // // // // 시설 조회에서도 넘어올 수 있네

import 'package:flutter/material.dart';
import 'package:front/performance_detail.dart';
import 'model/place_model.dart';
import 'model/performance_model.dart';
import 'services/api.dart';

class PlaceDetail extends StatefulWidget {
  final String id;

  const PlaceDetail({Key? key, required this.id}) : super(key: key);

  @override
  State<PlaceDetail> createState() => _PlaceDetailState();
}

class _PlaceDetailState extends State<PlaceDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('시설 상세 조회 결과 ${widget.id}'),
      ),
      body: SingleChildScrollView(
        // Add SingleChildScrollView
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<Place?>(
                future: Api.getPlaceById(widget.id),
                builder: (context, AsyncSnapshot<Place?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Text('No place data available.');
                  } else {
                    Place place = snapshot.data!;
                    return Column(
                      children: [
                        Card(
                          child: Column(
                            children: [
                              Text("여긴 ${place.name.toString()} 시야정보?"),
                              const SizedBox(height: 200),
                            ],
                          ),
                        ),
                        Card(
                          child: Column(
                            children: [
                              const Text('공연장 상세 정보'),
                              Text('이름 :  ${place.name.toString()}'),
                              Text('개관연도 :  ${place.open.toString()}'),
                              Text('규모 :  ${place.scale.toString()}'),
                              Text('전화번호 :  ${place.tele.toString()}'),
                              Text('URL :  ${place.url.toString()}'),
                              Text('주소 :  ${place.adres.toString()}'),
                              Text('주차장 :  ${place.parking.toString()}'),
                              Text('특성 :  ${place.chart.toString()}'),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            const Text('여기서 열릴 공연 목록들'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<List<Performance>>(
                future: Api.getPerformanceInThisPlace(widget.id),
                builder: (context, AsyncSnapshot<List<Performance>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No performance data available.');
                  } else {
                    return Column(
                      children: snapshot.data!.map((performance) {
                        return Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('이름 :  ${performance.name.toString()}'),
                              Text('공연장 :  ${performance.place.toString()}'),
                              Text(
                                  '기간 :  ${performance.startDate.toString()} - ${performance.endDate.toString()}'),
                              TextButton(
                                  onPressed: () {
                                    // Navigate to the desired page here
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PerformanceDetail(
                                          performance: performance,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('공연 상세 페이지로 이동'))
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'model/place_model.dart';
// import 'model/performance_model.dart';
// import 'services/api.dart';

// class PlaceDetail extends StatefulWidget {
//   final String id;

//   const PlaceDetail({Key? key, required this.id}) : super(key: key);

//   @override
//   State<PlaceDetail> createState() => _PlaceDetailState();
// }

// class _PlaceDetailState extends State<PlaceDetail> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('시설 상세 조회 결과 ${widget.id}'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: FutureBuilder<Place?>(
//               future: Api.getPlaceById(widget.id),
//               builder: (context, AsyncSnapshot<Place?> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const CircularProgressIndicator();
//                 } else if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 } else if (!snapshot.hasData || snapshot.data == null) {
//                   return const Text('No place data available.');
//                 } else {
//                   Place place = snapshot.data!;
//                   return Column(
//                     children: [
//                       Card(
//                         child: Column(
//                           children: [
//                             Text("여긴 ${place.name.toString()} 시야정보?"),
//                             const SizedBox(height: 200),
//                           ],
//                         ),
//                       ),
//                       Card(
//                         child: Column(
//                           children: [
//                             const Text('공연장 상세 정보'),
//                             Text('이름 :  ${place.name.toString()}'),
//                             Text('개관연도 :  ${place.open.toString()}'),
//                             Text('규모 :  ${place.scale.toString()}'),
//                             Text('전화번호 :  ${place.tele.toString()}'),
//                             Text('URL :  ${place.url.toString()}'),
//                             Text('주소 :  ${place.adres.toString()}'),
//                             Text('주차장 :  ${place.parking.toString()}'),
//                             Text('특성 :  ${place.chart.toString()}'),
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 }
//               },
//             ),
//           ),
//           const Text('여기서 열릴 공연 목록들'),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: FutureBuilder<List<Performance>>(
//               future: Api.getPerformanceInThisPlace(widget.id),
//               builder: (context, AsyncSnapshot<List<Performance>> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const CircularProgressIndicator();
//                 } else if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Text('No performance data available.');
//                 } else {
//                   return Column(
//                     children: snapshot.data!.map((performance) {
//                       return Card(
//                         child: Column(
//                           children: [
//                             Text('이름 :  ${performance.name.toString()}'),
//                             Text('개관연도 :  ${performance.age.toString()}'),
//                             Text('규모 :  ${performance.area.toString()}'),
//                             Text('전화번호 :  ${performance.place.toString()}'),
//                             Text('URL :  ${performance.price.toString()}'),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
