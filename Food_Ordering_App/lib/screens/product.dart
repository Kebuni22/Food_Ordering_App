import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDescriptionPage extends StatelessWidget {
  final String itemName;
  final String itemPrice;
  final String itemImgUrl;

  ProductDescriptionPage({
    required this.itemName,
    required this.itemPrice,
    required this.itemImgUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Description'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(itemImgUrl),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemName,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    itemPrice,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      placeOrder();
                    },
                    child: Text('Buy Now'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      addToCart();
                    },
                    child: Text('Add To Cart'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> placeOrder() async {
    final cartItemsSnapshot =
        await FirebaseFirestore.instance.collection('cart').get();

    if (cartItemsSnapshot.docs.isNotEmpty) {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final DatabaseReference _databaseRef =
          FirebaseDatabase.instance.reference();

      for (final item in cartItemsSnapshot.docs) {
        final data = item.data() as Map<String, dynamic>;
        final title = data['name'];
        final price = data['price'];
        final imageUrl = data['img'];

        final User? user = _auth.currentUser;
        if (user != null) {
          final userId = user.uid;

          String? orderId = _databaseRef.child("Orders").push().key;
          String timestamp = DateTime.now().toLocal().toString();

          Map<String, dynamic> orderData = {
            "userid": userId,
            "orderid": orderId,
            "name": title,
            "price": price,
            "imageUrl": imageUrl,
            "timestamp": timestamp,
          };

          try {
            await _databaseRef.child("Orders").child(orderId!).set(orderData);
            await FirebaseFirestore.instance
                .collection('cart')
                .doc(item.id)
                .delete();
            print("Order Placed");
          } catch (error) {
            print("Error placing order: $error");
          }
        } else {
          print("User is not authenticated.");
        }
      }
    }
  }

  void addToCart() {
    Map<String, dynamic> cartData = {
      'name': itemName,
      'price': itemPrice,
      'img': itemImgUrl,
    };

    FirebaseFirestore.instance.collection('cart').add(cartData).then((value) {
      print('Item added to cart successfully!');
    }).catchError((error) {
      print('Failed to add item to cart: $error');
    });
  }
}
