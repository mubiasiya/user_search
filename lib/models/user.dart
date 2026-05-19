import 'package:user_search/models/address.dart';
import 'package:user_search/models/company.dart';

class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final Address address;
  final String phone;
  final String website;
  final company comp;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
    required this.comp,
  });

  factory User.fromjson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int? ?? -1,
      name: json['name'] as String? ?? 'unknown',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      address:
          json['address'] != null
              ? Address.fromjson(json['address'])
              : Address.empty(),
      phone: json['phone'] as String? ?? '',
      website: json['website'] as String? ?? '',
      comp:
          json['company'] != null
              ? company.fromjson(json['company'])
              : company.empty(),
    );
  }

  Map<String, dynamic> tojson() {
    return {
      "id": id,

      "name": name,
      "username": username,
      "email": email,
      "address": {
        "street": address.street,
        "suite": address.suite,
        "city": address.city,
        "zipcode": address.zipcode,
        "geo": address.geo.tojson(),
      },
      "phone": phone,
      "website": website,
      "company": comp.tojson(),
    };
  }
}
