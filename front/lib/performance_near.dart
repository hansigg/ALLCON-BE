// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:front/performance_detail.dart';
import 'model/performance_model.dart';
import 'services/api.dart';

// 7일 이내의 임박한 공연을 보여주는 페이지
// services의 api.dart를 import해서 getPerformanceApproaching를 FutureBuilder로 가져와서 사용!

class PerformanceNear extends StatefulWidget {
  const PerformanceNear({super.key});

  @override
  State<PerformanceNear> createState() => _PerformanceNearState();
}

class _PerformanceNearState extends State<PerformanceNear> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('임박 공연 목록'),
      ),
      body: Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: FutureBuilder<List<Performance>>(
            future: Api.getPerformanceApproaching(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('에러: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('데이터 없음');
              } else {
                return ListView.builder(
                  padding: const EdgeInsets.only(right: 8.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, imgIndex) {
                    return GestureDetector(
                      onTap: () {
                        print(
                            "Tapped on image with ID: ${snapshot.data![imgIndex].id}");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PerformanceDetail(
                              performance: snapshot.data![imgIndex],
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Text(
                            '${snapshot.data![imgIndex].startDate} ~ ${snapshot.data![imgIndex].endDate}'
                                .toString(),
                          ),
                          Text(snapshot.data![imgIndex].name.toString()),
                          Image.network(
                            snapshot.data![imgIndex].poster ?? '',
                            fit: BoxFit.cover,
                            width: 200,
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
