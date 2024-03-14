// // ignore_for_file: library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:front/performance_date_2.dart';

// class PerformanceByDate extends StatefulWidget {
//   const PerformanceByDate({Key? key}) : super(key: key);

//   @override
//   _PerformanceByDateState createState() => _PerformanceByDateState();
// }

// class _PerformanceByDateState extends State<PerformanceByDate> {
//   List<DateTimeRange> selectedDateRanges = [];

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTimeRange? picked = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );

//     if (picked != null) {
//       setState(() {
//         // Clear the previous selections and add the new one
//         selectedDateRanges = [picked];
//       });
//     }
//   }

//   String _formatDate(DateTime date) {
//     return date.toLocal().toString().split(' ')[0].replaceAll('-', '');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('날짜로 조회\n근데 이건 쓸 일이 없을 걱 ㅏㅌ은데'),
//       ),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: () => _selectDate(context),
//             child: const Text('날짜 범위를 선택'),
//           ),
//           if (selectedDateRanges.isNotEmpty)
//             Column(
//               children: selectedDateRanges
//                   .map(
//                     (dateRange) => Column(
//                       children: [
//                         Text(
//                           'Start Date ${_formatDate(dateRange.start)}',
//                           style: const TextStyle(fontSize: 18),
//                         ),
//                         Text(
//                           'End Date: ${_formatDate(dateRange.end)}',
//                           style: const TextStyle(fontSize: 18),
//                         ),
//                       ],
//                     ),
//                   )
//                   .toList(),
//             ),
//           ElevatedButton(
//             onPressed: () {
//               if (selectedDateRanges.isNotEmpty) {
//                 for (DateTimeRange dateRange in selectedDateRanges) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => PerformanceByDateResult(
//                         startDate: _formatDate(dateRange.start),
//                         endDate: _formatDate(dateRange.end),
//                       ),
//                     ),
//                   );
//                 }
//               } else {
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       title: const Text("날짜 선택"),
//                       content: const Text("날짜를 먼저 선택하세요."),
//                       actions: [
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: const Text("확인"),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               }
//             },
//             child: const Text('고른 날짜로 이동'),
//           ),
//         ],
//       ),
//     );
//   }
// }
