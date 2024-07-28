import 'package:dine_ease2/BookingScreen.dart';
import 'package:dine_ease2/components/my_button.dart';
import 'package:flutter/material.dart';
import 'restaurantsApiHandler.dart'; // Import the file containing the getFoodItems function

class MenuScreen extends StatefulWidget {
  final String restaurantName;

  const MenuScreen({Key? key, required this.restaurantName}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Map<String, dynamic>> foodItems = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchFoodItems();
  }

  Future<void> _fetchFoodItems() async {
    try {
      List<Map<String, dynamic>>? loadedFoodItems = await getFoodItems(widget.restaurantName);

      if (loadedFoodItems != null) {
        setState(() {
          foodItems = loadedFoodItems;
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
          ? Center(child: Text('Failed to load food items'))
          : Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: foodItems.length,
              itemBuilder: (context, index) {
                final item = foodItems[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.network(item['imageURL'] ,
                            height: 200 ,
                            width: 200,
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Price: \$${item['price']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Size: ${item['size']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Category: ${item['category']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            )



                          ],
                        ),


                        SizedBox(height: 5),
                        Text('Description: ${item['description']}'),
                        SizedBox(height: 5),
                        Text('Calories: ${item['calories']}'),
                        SizedBox(height: 5),
                        Text('Ingredients: ${item['ingredients'].join(', ')}'),
                        SizedBox(height: 5),
                        Text('Spiciness Level: ${item['spiciness_level']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: MyButton(text: "Go to booking page" ,
              onTap: ()=> {
                  Navigator.pop(context),
              },
            ),
          ),
        ],
      ),
    );
  }

}
