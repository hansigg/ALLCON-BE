import 'package:flutter/material.dart';
import 'package:front/place_list_2.dart';

// 시설 지역 조회하는 페이지 list1,2,3으로 이동

class PlaceList extends StatefulWidget {
  const PlaceList({Key? key}) : super(key: key);

  @override
  State<PlaceList> createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {
  String selectedRegion = '서울';
  final List<String> regions = [
    '서울',
    '경기,인천',
    '충청권',
    '경상권',
    '전라권',
    '강원권',
    '제주권'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('시설 지역 조회 (1/3)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selected Region:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: regions.map((region) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedRegion = region;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: selectedRegion == region
                          ? Colors.indigo
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.indigo),
                    ),
                    child: Text(
                      region,
                      style: TextStyle(
                        fontSize: 16,
                        color: selectedRegion == region
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a new screen with the selected region's results
          Navigator.push(
            context,
            MaterialPageRoute(
              // Result 페이지로 선택한 지역권(String)을 전달함
              builder: (context) => PlaceListResult(area: selectedRegion),
            ),
          );
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
