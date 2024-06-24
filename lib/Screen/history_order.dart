// history_order.dart

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jb_store/Components/bottom_navbar.dart';
import 'package:jb_store/Components/drawer_widget.dart';
import 'package:jb_store/Screen/Profile/profile_page.dart';
import 'package:jb_store/Screen/home_screen.dart';
import 'package:jb_store/models/globals.dart';
import 'package:jb_store/screen/all_product.dart';
import 'package:jb_store/screen/order.dart';
import 'package:jb_store/services/api_product.dart';
import '../Models/product.dart';

class HistoryOrderScreen extends StatefulWidget {
  HistoryOrderScreen({Key? key}) : super(key: historyOrderScreenStateKey);

  @override
  HistoryOrderScreenState createState() => HistoryOrderScreenState();
}

class HistoryOrderScreenState extends State<HistoryOrderScreen> {
  late Future<List<Product>> futureProducts;
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Navigate to Home
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
        break;
      case 1:
        // Navigate to Orders
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AllProductsScreen()));
        break;
      case 2:
        // Navigate to History
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OrderScreen()));
        break;
      case 3:
        // Navigate to Profile
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HistoryOrderScreen()));
        break;
      case 4:
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfileScreen()));
    }
  } // Update initial index to 1

  @override
  void initState() {
    super.initState();
    futureProducts = ApiProduct().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Order'),
      ),
      drawer: DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Failed to load products'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No products found'));
                  } else {
                    List<Product> products = snapshot.data!;
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return HistoryProductCard(
                          product: products[index],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HistoryProductCard extends StatelessWidget {
  final Product product;

  const HistoryProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1,
            blurRadius: 1,
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.inventory_outlined,
                size: 24.0,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Text('Category: 21 maret 2022'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Image.network(
                product.image,
                width: 50.0,
                height: 50.0,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Category: ${product.category}'),
                    Text("Price: \$${product.price}"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Received',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              )
            ],
          ),
        ],
      ),
    );
  }
}
