import 'package:assone/auth_helper.dart';
import 'package:assone/map_utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:assone/screens/product.dart';
import 'package:assone/screens/cart.dart';
import 'package:assone/screens/orders.dart';

class home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Kade'),
        backgroundColor: Colors.green, // Set app bar background color
        actions: [
          IconButton(
            onPressed: () {
              // Show logout confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Logout Confirmation'),
                    content: Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Perform the logout action here
                          AuthHelper.instance.logout(context);
                        },
                        child: Text('Yes, Logout'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // If we're here, we've got data
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          return GridView.builder(
            padding: EdgeInsets.all(10.0), // Add padding around grid
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 10.0, // Spacing between columns
              mainAxisSpacing: 10.0, // Spacing between rows
              childAspectRatio: 0.75, // Ratio of child height to child width
            ),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              // Here you can access each document and extract data
              final itemData = documents[index].data() as Map<String, dynamic>;
              final String itemName = itemData['name']; // Item Name
              final String itemPrice =
                  'Rs ${itemData['price'].toString()}'; // Item Price
              final String itemImgUrl =
                  itemData['img']; // URL of the item image
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDescriptionPage(
                        itemName: itemName,
                        itemPrice: itemPrice,
                        itemImgUrl: itemImgUrl,
                      ),
                    ),
                  );
                },
                child: GridTile(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                            child: Image.network(
                              itemImgUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                itemName,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                itemPrice,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
            tooltip: 'Cart',
            child: Icon(Icons.shopping_cart),
            backgroundColor: Colors.green,
          ),
          SizedBox(height: 16.0),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FirebaseItemsPage()),
              );
            },
            tooltip: 'My Orders',
            child: Icon(Icons.list),
            backgroundColor: Colors.green,
          ),
          SizedBox(height: 16.0),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapPage()),
              );
            },
            tooltip: 'Map',
            child: Icon(Icons.map),
            backgroundColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
