import 'package:user_search/models/geo.dart';

class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final Geo geo;

  Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  factory Address.fromjson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] as String? ?? '',
      suite: json['suite'] as String? ?? '',
      city: json['city'] as String? ?? '',
      zipcode: json['zipcode'] as String? ?? '',
      geo: json['geo'] != null ? Geo.fromjson(json['geo']) : Geo.empty(),
    );
  }

  factory Address.empty() {
    return Address(
      suite: '',
      city: '',
      street: '',
      zipcode: '',
      geo: Geo.empty(),
    );
  }

  Map<String, dynamic> tojson() {
    return {
      "street": street,
      "suite": suite,
      "city": city,
      "zipcode": zipcode,
      'geo': geo.tojson(),
    };
  }
}
