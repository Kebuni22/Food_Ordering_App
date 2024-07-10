import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseItemsPage extends StatefulWidget {
  @override
  _FirebaseItemsPageState createState() => _FirebaseItemsPageState();
}

class _FirebaseItemsPageState extends State<FirebaseItemsPage> {
  late DatabaseReference _ordersRef;
  List<Map<dynamic, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    // Initialize Firebase
    Firebase.initializeApp();
    // Initialize the DatabaseReference
    _ordersRef = FirebaseDatabase.instance.reference().child('Orders');
    // Listen for changes in the database
    _ordersRef.onValue.listen((event) {
      setState(() {
        final Map<dynamic, dynamic>? values =
            event.snapshot.value as Map<dynamic, dynamic>? ?? {};
        _orders = values!.entries
            .map((entry) => entry.value as Map<dynamic, dynamic>)
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Orders'),
      ),
      body: ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (context, index) { 
          final order = _orders[index];
          final imageUrl = order['imageUrl'] ?? ''; // Handle null img
          final name = order['name'] ?? 'Unknown'; // Handle null name
          final price = order['price'] != null
              ? '\$${order['price']}'
              : 'Price not available'; // Handle null price
          return ListTile(
            leading: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 50,
                    height: 50,
                  )
                : SizedBox(
                    width: 50, height: 50), // Placeholder if imageUrl is empty
            title: Text(name),
            subtitle: Text(price),
          );
        },
      ),
    );
  }
}
