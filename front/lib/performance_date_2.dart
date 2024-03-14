// import 'package:flutter/material.dart';
// import 'services/api.dart';
// import 'model/performance_model.dart';

// class PerformanceByDateResult extends StatefulWidget {
//   final String startDate;
//   final String endDate;

//   const PerformanceByDateResult(
//       {super.key, required this.startDate, required this.endDate});

//   @override
//   State<PerformanceByDateResult> createState() =>
//       _PerformanceByDateResultState();
// }

// class _PerformanceByDateResultState extends State<PerformanceByDateResult> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Column(
//           children: [
//             const Text("공연목록 조회 (2/2)"),
//             const SizedBox(height: 2),
//             Text(
//               " ${widget.startDate} ~ ${widget.endDate} ",
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Colors.black54,
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: FutureBuilder(
//         future: Api.getPerformanceByDate(widget.startDate, widget.endDate),
//         builder: (context, AsyncSnapshot<List<Performance>> snapshot) {
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
//                 return Column(
//                   children: [
//                     Text('${performance.name}'),
//                     // Add additional information or widgets related to each performance
//                     Text('Start Date: ${performance.startDate}'),
//                     Text('End Date: ${performance.endDate}'),
//                     // ... add more information as needed
//                     const SizedBox(
//                         height:
//                             30), // Add some spacing between each performance
//                   ],
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
