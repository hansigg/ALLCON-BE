import 'package:flutter/material.dart';
import 'package:front/services/api.dart';
import 'model/performance_model.dart';

// DB에 존재하는 모든 공연 정보를 가져오는 페이지

// services의 api.dart를 import해서 getPerformance를 FutureBuilder로 가져와서 사용!

class PerformanceAll extends StatefulWidget {
  const PerformanceAll({super.key});

  @override
  State<PerformanceAll> createState() => _PerformanceAllState();
}

class _PerformanceAllState extends State<PerformanceAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공연 전체 조회'),
      ),
      body: FutureBuilder(
        future: Api.getPerformance(),
        builder: (context, AsyncSnapshot<List<Performance>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No performances available.');
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
                      Text(performance.price.toString()),
                      Text(
                        '${performance.startDate.toString()} ~ ${performance.endDate.toString()}',
                      )
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


// 1. toString을 반드시 붙여야하나? 모르겠음

// 2. performance model에 있는 데이터들은 모두 사용 가능 / 간단하게 이름, 장소, 가격만 가져왔음