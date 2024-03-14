import 'package:flutter/material.dart';
import 'package:front/place_detail.dart';
import 'services/api.dart';
import 'model/place_model.dart';

class PlaceSearchResult extends StatefulWidget {
  final String text;

  const PlaceSearchResult({super.key, required this.text});

  @override
  State<PlaceSearchResult> createState() => _PlaceSearchResultState();
}

class _PlaceSearchResultState extends State<PlaceSearchResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.text} - 검색 결과'),
      ),
      body: FutureBuilder(
          future: Api.getPlaceByName(widget.text),
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
                  return Card(
                    child: Column(
                      children: [
                        const Text('그냥 column에서 대충 보여주는 중'),
                        Text(place.name.toString()),
                        Text(place.adres.toString()),
                        Text('시설 특성? ${place.chart.toString()}'),
                        Text('시설 오픈 연도? ${place.open.toString()}'),
                        Text('주차장 여부 ${place.parking.toString()}'),
                        Text('수용인원 ${place.scale.toString()}'),
                        Text('전화번호 ${place.tele.toString()}'),
                        TextButton(
                          onPressed: () {
                            // Navigate to the desired page here
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PlaceDetail(
                                          id: place.id.toString(),
                                        )));
                          },
                          child: const Text(
                            '공연장 상세 페이지로 이동',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}
