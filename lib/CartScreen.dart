import 'package:dine_ease2/restaurantsApiHandler.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const CartScreen({Key? key, required this.cartItems}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [];
  double totalBill = 0;

  @override
  void initState() {
    super.initState();
    cartItems = List.from(widget.cartItems);
    _calculateTotalBill();
  }

  void _incrementItemQuantity(Map<String, dynamic> foodItem) {
    setState(() {
      int index = cartItems.indexWhere((item) => item['name'] == foodItem['name']);
      if (index != -1) {
        cartItems[index]['quantity'] += 1;
        _calculateTotalBill();
      }
    });
  }

  void _decrementItemQuantity(Map<String, dynamic> foodItem) {
    setState(() {
      int index = cartItems.indexWhere((item) => item['name'] == foodItem['name']);
      if (index != -1) {
        if (cartItems[index]['quantity'] > 1) {
          cartItems[index]['quantity'] -= 1;
        } else {
          cartItems.removeAt(index);
        }
        _calculateTotalBill();
      }
    });
  }

  void _calculateTotalBill() {
    totalBill = 0;
    for (var item in cartItems) {
      totalBill += item['quantity'] * item['price'];
    }
  }

  void _makePayment() {
    // Implement payment logic here
    String bill = totalBill.toString();
    makePayment(context , bill);
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Payment successful!')),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, cartItems);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cart'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    double itemTotal = item['quantity'] * item['price'];

                    return Card(
                      child: ListTile(
                        leading: Image.network(
                          item['imageURL'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(item['name']),
                        subtitle: Text('Price: \$${item['price']} - Quantity: ${item['quantity']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => _decrementItemQuantity(item),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => _incrementItemQuantity(item),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _makePayment,
                child: Text('Pay \$${totalBill.toStringAsFixed(2)}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
