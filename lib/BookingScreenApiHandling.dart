import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

// Define a class to hold the request ID and response data
class TableRequestResponse {
  final String requestId;
  final String? responseData;

  TableRequestResponse({required this.requestId, this.responseData});
}

Future<TableRequestResponse?> requestForTable(String name, String NoOFTables, String NoOFChairs, double timeInMinutes) async {
  // Define the URL of the API endpoint
  const String apiUrl = 'http://192.168.0.139:4000/tableRequests';

  // Generate a random ID
  String requestId = Uuid().v4();

  // Prepare the data to be sent to the API
  Map<String, dynamic> requestData = {
    'Id': requestId, // Include the random ID
    'Name': name,
    'NoOfTables': NoOFTables,
    'NoOfChairs': NoOFChairs,
    'TimeInMinutes': timeInMinutes,
  };

  // Convert the data to JSON format
  String requestBody = jsonEncode(requestData);

  try {
    // Make the API call
    http.Response response = await http.post(
      Uri.parse(apiUrl), // Directly parse the URL string to Uri
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: requestBody,
    );

    // Check if the call was successful (status code 200)
    if (response.statusCode == 200) {
      // API call successful, do something with the response
      String data = response.body;
      print('API call successful: $data');
      return TableRequestResponse(requestId: requestId, responseData: data);
    } else {
      // API call failed
      print('Failed to call API: ${response.statusCode}');
      return TableRequestResponse(requestId: requestId, responseData: null);
    }
  } catch (error) {
    // Error occurred during the API call
    print('Error calling API: $error');
    return TableRequestResponse(requestId: requestId, responseData: null);
  }
}


Future<String> fetchAnswer(String id) async {
  print("Received ID from previous class: $id");
  const String apiUrl = 'http://192.168.0.139:4000/answer';

  try {
    // Make the GET request
    http.Response response = await http.get(Uri.parse(apiUrl));

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse and print the response body
      List<dynamic> data = jsonDecode(response.body);
      print('API call successful: $data');
      // Iterate through the list
      for (var item in data) {
        // Assuming each item is a map and has a 'mobileID' key
        if (item['mobileID'] == id) {
          return item['approved'];
        }
      }
    } else {
      // Request failed
      print('Failed to call API: ${response.statusCode}');
    }
  } catch (error) {
    // Error occurred during the API call
    print('Error calling API: $error');
  }

  return "Not Responded";
}




