import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:assone/model/colors.dart';

class Product extends StatefulWidget {
  final Map<String, dynamic> burgerData;

  Product({required this.burgerData, Key? key}) : super(key: key);

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  int quantity = 1;
  double parsedPrice = 0.0;

  @override
  void initState() {
    super.initState();
    parsePrice();
  }

  void parsePrice() {
    final price = widget.burgerData['price'];
    final formattedPrice = double.tryParse(price ?? "");
    if (formattedPrice != null) {
      setState(() {
        parsedPrice = formattedPrice;
      });
    }
  }

  double calculateTotal() {
    return parsedPrice * quantity;
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.burgerData['title'] ?? "Default Title";
    final price = widget.burgerData['price'];
    final description =
        widget.burgerData['description'] ?? "Default Description";
    final imageUrl = widget.burgerData['imageUrl'] ?? "Default Image URL";

    final formattedPrice = double.tryParse(price ?? "");
    final displayPrice = formattedPrice != null
        ? 'Rs. ${formattedPrice.toStringAsFixed(2)}'
        : 'Invalid Price';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Food Kade',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: mainColor,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 2.5,
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Expanded(
            child: scroll(title, displayPrice, description),
          ),
        ],
      ),
    );
  }

  Widget scroll(String title, String price, String description) {
    return DraggableScrollableSheet(
      initialChildSize: 1.0,
      maxChildSize: 1.0,
      minChildSize: 1.0,
      builder: (context, ScrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            controller: ScrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 5,
                        width: 35,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                color: mainColor,
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  width: 50,
                ),
                Row(
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Description",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: mainColor,
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            if (quantity > 1) {
                              setState(() {
                                quantity--;
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 40),
                      alignment: Alignment.center,
                      child: Text(
                        quantity.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 35,
                      height: 35,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: mainColor,
                      ),
                      child: IconButton(
                        alignment: Alignment.center,
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        icon: Container(
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      'Total = ',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      calculateTotal().toString(),
                      style: const TextStyle(
                        fontSize: 17,
                        color: mainColor,
                      ),
                    ),
                    Spacer(),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: ElevatedButton.icon(
                        onPressed: () => placeOrder(),
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text(
                          "Buy Now",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 49, 180, 53),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> placeOrder() async {
    CollectionReference ordersCollection =
        FirebaseFirestore.instance.collection("orders");

    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is signed in, include the UID in the order data
      String userUID = user.uid;

      // Add data to the "orders" collection
      await ordersCollection.add({
        "title": widget.burgerData['title'],
        "price": widget.burgerData['price'],
        // Assuming 'imageUrl' is the image name, you can adjust this according to your actual data
        "imageName": widget.burgerData['imageUrl'],
        // Add other necessary fields related to the order
        "userUID": userUID, // Include the user's UID in the data
        "timestamp": DateTime.now(), // Include timestamp for ordering time
      }).then((value) {
        print('Order Placed');
        // Show a SnackBar to confirm the order has been placed
        const snackBar = SnackBar(
          content: Text('Order Placed'),
          duration: Duration(seconds: 2),
          backgroundColor: mainColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }).catchError((error) {
        print("Failed to place order: $error");
      });
    } else {
      print('User is not signed in');
    }
  }
}
