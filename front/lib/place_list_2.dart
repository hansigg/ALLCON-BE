import 'package:flutter/material.dart';
import 'package:front/place_detail.dart';
import 'services/api.dart';
import 'model/place_model.dart';

class PlaceListResult extends StatefulWidget {
  final String area;

  const PlaceListResult({Key? key, required this.area}) : super(key: key);

  @override
  State<PlaceListResult> createState() => _PlaceListResultState();
}

class _PlaceListResultState extends State<PlaceListResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('시설 지역 조회 (2/3) - ${widget.area}'),
      ),
      body: FutureBuilder(
        future: Api.getPlace(widget.area),
        builder: (context, AsyncSnapshot<List<Place>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No performances available.'));
          } else {
            List<Place> places = snapshot.data!;
            return ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) {
                Place place = places[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InkWell(
                    onTap: () {
                      // Navigate to the detail page when the item is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PlaceDetail(id: place.id.toString()),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          '${place.name}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue, // 링크 색상
                          ),
                        ),
                      ],
                    ),
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
