class Geo {
  final String lat;
  final String lng;

  Geo({required this.lat, required this.lng});

  factory Geo.fromjson(Map<String, dynamic> json) {
    return Geo(
      lat: json['lat'] as String? ?? '',
      lng: json['lng'] as String? ?? '',
    );
  }

  factory Geo.empty() {
    return Geo(lat: '', lng: '');
  }

  Map<String, dynamic> tojson() {
    return {'lat': lat, 'lng': lng};
  }
}
