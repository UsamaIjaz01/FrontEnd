import 'package:flutter/material.dart';

import '../BookingScreen.dart';
import '../registeredrestaurants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _searchController = TextEditingController();
  late Future<List<dynamic>> _futureRestaurants;
  List<dynamic> _allRestaurants = [];
  List<dynamic> _filteredRestaurants = [];

  @override
  void initState() {
    super.initState();
    _futureRestaurants = fetchRestaurants();
    _futureRestaurants.then((restaurants) {
      setState(() {
        _allRestaurants = restaurants;
        _filteredRestaurants = restaurants;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredRestaurants = _allRestaurants;

      } else {
        _filteredRestaurants = _allRestaurants
            .where((restaurant) =>
            restaurant['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Color backgroundColor = Color(int.parse('0xFF927053'));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          // Slogan for the app
          Padding(
            padding: EdgeInsets.fromLTRB(50.0, 70.0, 50.0, 9.0),
            child: Text(
              "Make Your Every Meal A Celebration",
              style: TextStyle(
                fontSize: 24, // Larger font size
                fontWeight: FontWeight.bold, // Bold text
                color: Theme.of(context).colorScheme.inversePrimary, // Custom color
                letterSpacing: 1.2, // Adds space between letters
              ),
              textAlign: TextAlign.center, // Center align the text
            ),
          ),
          // Search bar for advanced search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0 , vertical: 10),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchTextChanged, // Register the onChanged callback
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                hintText: "Find Your Food..",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
          ),

          // Restaurant cards
          // Expanded widget to take remaining space
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _futureRestaurants,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView.builder(

                    itemCount: _filteredRestaurants.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingScreen(
                                  restaurant: _filteredRestaurants[index]),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            // color: Colors.white,
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  "${_filteredRestaurants[index]['img_url']}",
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                    // In case of error, show the default asset image
                                    return Image.asset(
                                      'assets/images/r.jpg',
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${_filteredRestaurants[index]['name']}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${_filteredRestaurants[index]['slogan']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.yellow),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Ratings: ${_filteredRestaurants[index]['ratings']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Starting Price: ${_filteredRestaurants[index]['startingPrice']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
