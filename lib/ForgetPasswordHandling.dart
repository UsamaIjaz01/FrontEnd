import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> getUserByEmail(String email) async {
  try {
    // Make a GET request to the API endpoint with the email query parameter
    var response = await http.get(Uri.parse('http://192.168.0.139:3000/forgetPassword?email=$email'));

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the JSON response body
      var userData = json.decode(response.body);

      if (userData.isNotEmpty) {
        // User found, return the user data
        return userData;
      } else {
        // No user found, return null
        return null;
      }
    } else {
      // Request failed with an error code
      print('Request failed with status: ${response.statusCode}');
      return null;
    }
  } catch (error) {
    // Error occurred during the request
    print('Error: $error');
    return null;
  }
}






