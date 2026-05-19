import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user_search/models/user.dart';

class Apiservice {
  final String baseUrl = "https://jsonplaceholder.typicode.com/users";

  Future<List<User>> fetch() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> rawList = jsonDecode(response.body);
        List<User> users = rawList.map((item) => User.fromjson(item)).toList();

        return users;
      } else {
        throw Exception(
          "Failed to load users. Status code: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Failed to load users. Status code: $e");
    }
  }
}
