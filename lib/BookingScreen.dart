import 'package:dine_ease2/BookingScreenApiHandling.dart';
import 'package:dine_ease2/MenuScreen.dart';
import 'package:dine_ease2/RestaurantDetailsScreen.dart';
import 'package:dine_ease2/components/my_button.dart';
import 'package:dine_ease2/components/my_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> restaurant;

  const BookingScreen({Key? key ,  required this.restaurant}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tablesController = TextEditingController();
  final TextEditingController _chairsController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  String? _errorMessage;


  late Map<String, dynamic> _restaurantDetails;
  late String name ;



  @override
  void initState() {
    super.initState();
    _restaurantDetails = widget.restaurant;
    print("------------------------------------------------------------------------------------------");
    print(widget.restaurant);
    print("------------------------------------------------------------------------------------------");
    name = _restaurantDetails['name'];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 1), // Add padding around the content
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(height: .0),
                    Center(
                      child: Image.asset(
                        "assets/images/booking.png",
                        height: 180,
                        width: 180,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    const Text(
                      "Before Placing Your Order Please Reserve Your Table",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    MyTextField(controller: _nameController, hintText: "Name", obscureText: false),
                    const SizedBox(height: 12),
                    MyTextField(
                      controller: _tablesController,
                      hintText: "No of tables you wanna book",
                      obscureText: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a valid no of tables';
                        } else if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    MyTextField(
                      controller: _chairsController,
                      hintText: "No of chairs on each table",
                      obscureText: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a valid no of tables';
                        } else if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    MyTextField(
                      controller: _timeController,
                      hintText: "Estimated Time of Arrival (In Minutes)",
                      obscureText: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter estimated time of arrival';
                        } else if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),

                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 32),
                    MyButton(text: "Check for table" ,
                      onTap: _onCheckButtonPressed,
                    ),
                    const SizedBox(height: 12),
                    MyButton(text: "Wanna check menu first?" ,
                      onTap: ()=>{
                      name = widget.restaurant['name'],
                        print(name),
                        print("taped"),
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)  =>  MenuScreen(restaurantName: 'Mera Dera')),
                        ),
                      },
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onCheckButtonPressed() {
    print("---------------------------------I N - C H E C K - B U T T O ---------------------------------------------------------");
    print(widget.restaurant['img_url']);
    print("------------------------------------------------------------------------------------------");
    String imageURL;
    if (widget.restaurant['img_url'] != null && widget.restaurant['img_url'].isNotEmpty) {
      imageURL = widget.restaurant['img_url'];
    } else {
      imageURL = "No Image Found"; // Or set a default image URL
    }


    setState(() {
      _errorMessage = _validateFields();
    });

    if (_errorMessage == null) {
      requestForTable(
        _nameController.text,
        _tablesController.text,
        _chairsController.text,
        double.parse(_timeController.text),
      ).then((response) {
        setState(() {
          if (response != null) {
            print("response from the post api is : ${response.requestId}");
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Request Delivered'),
                    content: const Text('Will let you know in next 15 Seconds\nPlease dont close the app.'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                          Navigator.push(
                            context,
                            // MaterialPageRoute(builder: (context)  => const MenuScreen(restaurantName: "Mera Dera")),
                            MaterialPageRoute(builder: (context) => RestaurantDetailsScreen(restaurant: _restaurantDetails , id: response.requestId , name: _nameController.text , imgURL: imageURL,)), // Navigate to the order screen
                          );
                        },
                        child: const Text('Place Order' , style: TextStyle(
                          color: Colors.black87,
                        ),),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set the background color
                        ),

                      ),
                    ],
                  );
                },
              );

          }
        });
      }).catchError((error) {
        setState(() {
          print('Error occurred: $error');
        });
      });
    }
  }


  String? _validateFields() {
    if (_nameController.text.isEmpty) {
      return 'Please enter your name';
    } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(_nameController.text)) {
      return 'Please enter a valid name (only alphabets and spaces)';
    }

    if (_tablesController.text.isEmpty) {
      return 'Please enter number of tables';
    } else if (int.parse(_tablesController.text) >= 5) {
      return 'Please enter a number for tables less than 5';
    }
    if (_chairsController.text.isEmpty) {
      return 'Please enter number of chairs';
    } else if (int.parse(_chairsController.text) >= 8) {
      return 'Please enter a number of chairs less than 8';
    }

    if (_timeController.text.isEmpty) {
      return 'Please enter estimated time of arrival';
    }
    return null;
  }

  Widget Loading(){
    return SpinKitFadingCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? Colors.red : Colors.green,
          ),
        );
      },
    );
  }
}
