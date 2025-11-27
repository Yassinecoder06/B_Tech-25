import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/styles/scroll_decorator.dart';

class PocketPage extends StatefulWidget {
  const PocketPage({super.key});

  @override
  _PocketPageState createState() => _PocketPageState();
}

class _PocketPageState extends State<PocketPage> {
  bool isLoading = true;
  List<Map<String, dynamic>> purchasedItems = [];

  @override
  void initState() {
    super.initState();
    fetchPurchasedItems();
  }

  Future<void> fetchPurchasedItems() async {
    try {
      var purchasesSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('purchases')
          .get();

      setState(() {
        purchasedItems = purchasesSnap.docs
            .map((doc) => doc.data())
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pocket", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 202, 137, 209),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ScrollDecorator(
              child: ListView.builder(
                itemCount: purchasedItems.length,
                itemBuilder: (context, index) {
                  final item = purchasedItems[index];
                  return ListTile(
                    leading: Icon(item['itemType'] == 'Coupon'
                        ? Icons.local_offer
                        : item['itemType'] == 'Discount'
                            ? Icons.discount
                            : item['itemType'] == 'Accommodation'
                                ? Icons.hotel
                                : Icons.fastfood),
                    title: Text(item['itemName']),
                    subtitle: Text(
                      'This is a ${item['itemType']}',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
    );
  }
}