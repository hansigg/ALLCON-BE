import 'package:flutter/material.dart';
import 'package:front/place_detail.dart';
import 'package:front/services/api.dart';
import 'model/performance_model.dart';

class PerformanceSearchResult extends StatefulWidget {
  final String text;

  const PerformanceSearchResult({Key? key, required this.text})
      : super(key: key);

  @override
  State<PerformanceSearchResult> createState() =>
      _PerformanceSearchResultState();
}

class _PerformanceSearchResultState extends State<PerformanceSearchResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.text} - 검색 결과'),
      ),
      body: FutureBuilder(
        future: Api.getPerformanceByName(widget.text),
        builder: (context, AsyncSnapshot<List<Performance>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No performances available.'));
          } else {
            List<Performance> performances = snapshot.data!;
            return ListView.builder(
              itemCount: performances.length,
              itemBuilder: (context, index) {
                Performance performance = performances[index];
                return Card(
                  child: Column(
                    children: [
                      Image.network(
                        performance.poster!,
                        width: 250.0,
                        height: 250.0,
                        fit: BoxFit.cover,
                      ),
                      Text(performance.name.toString()),
                      Text(performance.place.toString()),
                      Text(
                        '${performance.startDate.toString()} ~ ${performance.endDate.toString()}',
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlaceDetail(
                                  id: performance.id.toString(),
                                ),
                              ),
                            );
                          },
                          child: const Text('공연 상세 페이지로 이동'))
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:front/services/api.dart';
// import 'model/performance_model.dart';

// class PerformanceSearchResult extends StatefulWidget {
//   final String text;

//   const PerformanceSearchResult({super.key, required this.text});

//   @override
//   State<PerformanceSearchResult> createState() =>
//       _PerformanceSearchResultState();
// }

// class _PerformanceSearchResultState extends State<PerformanceSearchResult> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('${widget.text} -  검색 결과'),
//       ),
//       body: FutureBuilder(
//           future: Api.getPerformanceByName(widget.text), builder: (context, AsyncSnapshot<List<Performance>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const CircularProgressIndicator();
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Text('No performances available.');
//           } else {
//             List<Performance> performances = snapshot.data!;
//             return ListView.builder(
//               itemCount: performances.length,
//               itemBuilder: (context, index) {
//                 Performance performance = performances[index];
//                 return Card(
//                   child: Column(
//                     children: [
//                       Image.network(
//                         performance.poster!,
//                         width: 250.0,
//                         height: 250.0,
//                         fit: BoxFit.cover,
//                       ),
//                       Text(performance.name.toString()),
//                       Text(performance.place.toString()),
//                       Text(performance.price.toString()),
//                       Text(
//                         '${performance.startDate.toString()} ~ ${performance.endDate.toString()}',
//                       )
//                     ],
//                   ),
//                 ),);,
//     );
//   }
// }
