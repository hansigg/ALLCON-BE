// 시설 데이터 모델

class Place {
  final String? mid;
  final String? id;
  final String? name;
  final String? open;
  final String? scale;
  final String? tele;
  final String? url;
  final String? adres;
  final String? parking;
  final String? chart;

  Place({
    required this.mid,
    required this.id,
    required this.name,
    required this.open,
    required this.scale,
    required this.tele,
    required this.url,
    required this.adres,
    required this.parking,
    required this.chart,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      mid: json['_id'],
      id: json['id'],
      name: json['name'],
      open: json['open'],
      scale: json['scale'],
      tele: json['tele'],
      url: json['url'],
      adres: json['adres'],
      parking: json['parking'],
      chart: json['chart'],
    );
  }
}
