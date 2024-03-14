import 'package:flutter/material.dart';
import 'package:front/place_search_2.dart';

class PlaceSearch extends StatefulWidget {
  const PlaceSearch({super.key});

  @override
  State<PlaceSearch> createState() => _PlaceSearchState();
}

class _PlaceSearchState extends State<PlaceSearch> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('시설 검색 (1/2)'),
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
                  builder: (context) => PlaceSearchResult(
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
