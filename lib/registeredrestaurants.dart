import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchRestaurants() async {
  final response = await http.get(Uri.parse('http://192.168.0.139:3000/registered'));

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON response
    // and return the list of restaurants
    print(response.body);
    return jsonDecode(response.body);

  } else {
    // If the server returns an error response, throw an exception
    throw Exception('Failed to load restaurants');
  }
}
