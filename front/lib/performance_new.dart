import 'package:flutter/material.dart';
import 'services/api.dart';
import 'model/performance_model.dart';

class PerformanceNew extends StatefulWidget {
  const PerformanceNew({super.key});

  @override
  State<PerformanceNew> createState() => _PerformanceNewState();
}

class _PerformanceNewState extends State<PerformanceNew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('추가된 공연 (7일 이내)'),
      ),
      body: FutureBuilder(
        future: Api.getPerformanceNew(),
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
                      ),
                      Text('업데이트된 날짜 - ${performance.update.toString()}'),
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
