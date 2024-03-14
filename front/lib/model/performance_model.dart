// 공연 데이터 모델

class Performance {
  final String? mid;
  final String? id;
  final String? name;
  final String? startDate;
  final String? endDate;
  final String? price;
  final String? place;
  final String? placeId;
  final String? age;
  final String? area;
  final String? visit;
  final String? state;
  final String? time;
  final String? genre;
  final String? poster;
  final List<String>? imgs;
  final String? update;

  Performance({
    required this.mid,
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.place,
    required this.placeId,
    required this.age,
    required this.area,
    required this.visit,
    required this.state,
    required this.time,
    required this.genre,
    required this.poster,
    required this.imgs,
    required this.update,
  });

  factory Performance.fromJson(Map<String, dynamic> json) {
    return Performance(
      mid: json['_id'],
      id: json['id'],
      name: json['name'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      price: json['price'],
      place: json['place'],
      placeId: json['placeId'],
      age: json['age'],
      area: json['area'],
      visit: json['visit'],
      state: json['state'],
      time: json['time'],
      genre: json['genre'],
      poster: json['poster'],
      imgs: List<String>.from(json['imgs']),
      update: json['update'],
    );
  }
}
