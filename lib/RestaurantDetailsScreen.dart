import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dine_ease2/restaurantsApiHandler.dart';
import 'BookingScreenApiHandling.dart';
import 'CartScreen.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> restaurant;
  final String id, name, imgURL;

  const RestaurantDetailsScreen({
    Key? key,
    required this.restaurant,
    required this.id,
    required this.name,
    required this.imgURL,
  }) : super(key: key);

  @override
  _RestaurantDetailsScreenState createState() => _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  List<Map<String, dynamic>> cartItems = [];
  List<Map<String, dynamic>>? foodItems;
  List<Map<String, dynamic>>? filteredFoodItems;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    getFoodItems(widget.restaurant['name']).then((value) {
      setState(() {
        foodItems = value ?? [];
        filteredFoodItems = foodItems;
      });
    });
    _searchController.addListener(_onSearchChanged);
    // Start timer to fetch answer every 3 seconds
      Timer.periodic(Duration(seconds: 3), (Timer timer) {
        fetchAnswer(widget.id).then((String answer) {
          if (answer == 'Approved') {
            // Show dialog for approval
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Approval'),
                  content: Text('Your request has been approved.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          isButtonEnabled = true;
                        });
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
            timer.cancel(); // Stop the timer
          } else if (answer == 'No Space') {
            // Show dialog for denial
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Request Denied'),
                  content: Text('No space available.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
            timer.cancel(); // Stop the timer
          }
        });
      });

  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      filteredFoodItems = foodItems
          ?.where((item) => item['name'].toString().toLowerCase().contains(_searchQuery))
          .toList();
    });
  }

  void _addToCart(Map<String, dynamic> foodItem) {
    setState(() {
      int index = cartItems.indexWhere((item) => item['name'] == foodItem['name']);
      if (index != -1) {
        cartItems[index]['quantity'] += 1;
      } else {
        cartItems.add({...foodItem, 'quantity': 1});
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${foodItem['name']} added to cart')),
    );
  }

  void _viewCart() async {
    final updatedCartItems = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(cartItems: cartItems),
      ),
    );

    if (updatedCartItems != null) {
      setState(() {
        cartItems = updatedCartItems;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant['name']),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: _viewCart,
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Image.network(widget.imgURL),
            Container(
              padding: const EdgeInsets.fromLTRB(25, 10, 25, 5),
              color: Colors.white,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Food Items',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      _buildFoodItemsCards(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodItemsCards() {
    return filteredFoodItems != null
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        if (filteredFoodItems!.isNotEmpty)
          ...filteredFoodItems!.map((item) {
            return _buildFoodItemCard(item);
          }).toList(),
        if (filteredFoodItems!.isEmpty) const Text('No food items available'),
      ],
    )
        : const CircularProgressIndicator();
  }

  Widget _buildFoodItemCard(Map<String, dynamic> foodItem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 15, right: 15),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        image: DecorationImage(
                          image: NetworkImage(foodItem['imageURL']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          foodItem['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 11),
                        Text(
                          'Price: \$${foodItem['price']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 11),
                        Text(
                          'Size: ${foodItem['size']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 11),
                        Text(
                          'Category: ${foodItem['category']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: isButtonEnabled ? () => _addToCart(foodItem) : null,
                    child: Text('Add to cart'),
                  )

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
