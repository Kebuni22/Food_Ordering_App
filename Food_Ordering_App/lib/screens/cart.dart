import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CollectionReference cartCollection =
      FirebaseFirestore.instance.collection('cart');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: StreamBuilder(
        stream: cartCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No items in the cart.'),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                leading: Image.network(
                  data['img'] ?? 'Image not available',
                  width: 50,
                  height: 50,
                ),
                title: Text(data['name'] ?? 'No Name'),
                subtitle: Text('\$${data['price'] ?? 'Price not available'}'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
