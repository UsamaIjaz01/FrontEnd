import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import 'PaymentSuccessScreen.dart';



Future<List<Map<String, dynamic>>?> getFoodItems(String restaurantName) async {
  String name = restaurantName.replaceAll(RegExp(r'\s+'), '').toLowerCase();

  final response = await http.get(
    Uri.parse('http://192.168.0.139:3000/$name'),
  );

  if (response.statusCode == 200) {
    // Successful request
    print('Request successful');

    // Parse the JSON response body
    List<dynamic> jsonResponse = json.decode(response.body);

    // Convert each item to a map
    List<Map<String, dynamic>> foodItems = [];
    for (var item in jsonResponse) {
      foodItems.add({
        '_id': item['_id'] as String,
        'name': item['name'] as String,
        'price': item['price'] as double,
        'size': item['size'] as String,
        'category': item['category'] as String,
        'description': item['description'] as String,
        'calories': item['calories'] as int,
        'ingredients': List<String>.from(item['ingredients'] as List),
        'spiciness_level': item['spiciness_level'] as int,
        'imageURL': item['imageURL'] as String,
      });
    }

    return foodItems; // Return list of food items
  } else {
    // Handle error
    print('Error: ${response.statusCode}');
    return null; // or throw an exception or handle the error as needed
  }
}


Future<void> sendOrder(BuildContext context, List<Map<String, dynamic>> orderedItems , String name) async {
  print("sendOrderCalleddd");
  const url = 'http://192.168.0.139:4000/order'; // Replace with your server's URL

  final orderData = {
    "customerName": name, // Replace with actual customer name
    "items": orderedItems,
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(orderData),
    );

    if (response.statusCode == 201) {
      // Order was created successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order placed successfully!')),
      );


    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: ${response.reasonPhrase}')),
      );
    }
  } catch (error) {
    // Handle network or other errors
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to place order: $error')),
    );
  }

}


dynamic createPaymentIntent(String amount, String currency) async {
  print("----------...........=====================   $amount");
  print("-=-=========================================          $currency");


  try {
    final body = {
      'amount': amount,
      'currency': currency, // Ensure you are passing the correct currency
    };

    print(body);

    final response = await http.post(
      Uri.parse("http://192.168.0.139:4000/payment"),
      body: body,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    );

    return jsonDecode(response.body);
  } catch (err) {
    if (kDebugMode) {
      print(err);
    }
  }
}



Future<void> makePayment(BuildContext context , String price)async {
  try{
    print("IN TRYEEEE");
    final paymentIntentData = await createPaymentIntent(price,    'USD')  ?? {};
    await Stripe.instance
        .initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
      paymentIntentClientSecret: paymentIntentData['client_secret'],
      style: ThemeMode.light,
      customFlow: false ,
      merchantDisplayName: 'Usama',
    ),
    ).then((value) { displayPaymentSheet(context);
    });
  }
  catch(err) {
    if(kDebugMode){
      print("In make payment");
      print(err);
    }
  }
}
void displayPaymentSheet(BuildContext context) async {
  print("IN DISPLAY PAAYMENT SHEEETT");
  try {
    await Stripe.instance.presentPaymentSheet().then((value) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const PaymentSuccessScreen(),
        ),
      );

      // ScaffoldMessenger.of(context)
      //     .showSnackBar(
      //     const SnackBar(content: Text("Paid Successfully")));
    }).onError((error, stackTrace) => throw Exception(error));
  }
  on StripeException catch (e) {
    if (kDebugMode) {
      print("IN DIsplay payment sheeett");
      print(e);
    }
  }
}