import 'package:flutter/material.dart';
import 'package:front/performance_search_2.dart';

class PerformanceSearch extends StatefulWidget {
  const PerformanceSearch({Key? key}) : super(key: key);

  @override
  State<PerformanceSearch> createState() => _PerformanceSearchState();
}

class _PerformanceSearchState extends State<PerformanceSearch> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공연 검색 (1/2)'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: '검색어 입력',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // 사용자가 입력한 검색어를 새로운 페이지로 전달
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PerformanceSearchResult(
                    text: searchController.text,
                  ),
                ),
              );
            },
            child: const Text('검색'),
          ),
        ],
      ),
    );
  }
}
