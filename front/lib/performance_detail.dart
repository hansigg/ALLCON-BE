import 'package:flutter/material.dart';
import 'model/performance_model.dart';
import 'place_detail.dart';

class PerformanceDetail extends StatefulWidget {
  final Performance performance;

  const PerformanceDetail({Key? key, required this.performance})
      : super(key: key);

  @override
  State<PerformanceDetail> createState() => _PerformanceDetailState();
}

class _PerformanceDetailState extends State<PerformanceDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공연 세부 정보'),
      ),
      body: Column(
        children: [
          Image.network(
            widget.performance.poster ?? '',
            width: 250.0,
            height: 250.0,
            fit: BoxFit.cover,
          ),
          Text(widget.performance.name ?? 'Unknown'),
          Text(widget.performance.startDate ?? 'Unknown'),
          Text(widget.performance.endDate ?? 'Unknown'),
          Text(widget.performance.price ?? 'Unknown'),
          GestureDetector(
            onTap: () {
              // Navigate to the PlaceDetail page when Place is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PlaceDetail(id: widget.performance.placeId.toString()),
                ),
              );
            },
            child: Text(
              widget.performance.place ?? 'Unknown Place',
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Text(widget.performance.age ?? 'Unknown'),
          Text(widget.performance.area ?? 'Unknown'),
          Text('내한 ${widget.performance.visit}'),
          Text(widget.performance.state ?? 'Unknown'),
          Text(widget.performance.time ?? 'Unknown'),
          Text(widget.performance.genre ?? 'Unknown'),
          // Text(widget.performance.update ?? 'Unknown'),
          Text('최종 업데이트 ${widget.performance.update}'),
          if (widget.performance.imgs != null &&
              widget.performance.imgs!.isNotEmpty)
            SizedBox(
              height: 200.0,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.performance.imgs!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      widget.performance.imgs![index],
                      width: 400.0, // Adjust the width for larger images
                      height: 400.0, // Adjust the height for larger images
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
