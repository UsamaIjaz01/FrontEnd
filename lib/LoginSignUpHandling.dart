import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> loginUser(String id , String password) async {
  final response = await http.post(
    Uri.parse('http://192.168.0.139:3000/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'ID': id,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    // Successful login
    print('Login successful');
    print('Response: ${response.body}');
    return true;
  } else {
    // Handle error
    print('Error: ${response.statusCode}');
    return false;
  }
}


Future<bool> createAccount(String id , String password , String firstName , String lastName , String phoneNumber , String email) async {
  final response = await http.post(
    Uri.parse('http://192.168.0.139:3000/signup'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'ID': id,
      'password': password,
      'firstName': firstName ,
      'lastName': lastName ,
      'phoneNumber': phoneNumber,
      'email': email,
    }),
  );

  if (response.statusCode == 200) {
    // Successful login
    print('data inesrtTed');
    print('Response: ${response.body}');
    return true;
  } else {
    // Handle error
    print('Error: ${response.statusCode}');
    return false;
  }
}

Future<String?> sendOTP(String emailAddress) async {
  final response = await http.post(
    Uri.parse('http://192.168.0.139:3000/otpSender'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "Email": emailAddress,
    }),
  );

  if (response.statusCode == 200) {
    // Successful response
    print("everything is okkkkkkk " + response.body);
    return response.body;
  } else {
    // Handle error
    print('Error: ${response.statusCode}');
    return null;
  }
}


Future<String> otp(String e) async {

  String? otp = await sendOTP(e);
  if (otp != null) {
    // Use the OTP
    print('---------------->>>>>>>>>>>>>>>>>>>>>>>  ' + otp);
    return otp;
  } else {
    // Handle the case where OTP retrieval failed
    print("in else part =================================================================");
    return "Nothing found";
  }
}
