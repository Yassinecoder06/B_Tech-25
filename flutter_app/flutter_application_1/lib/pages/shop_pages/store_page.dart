import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/reward_coins_provider.dart';
import 'exchange_page.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  // State variable to hold the selected price
  String selectedPrice = '\$0.00';

  @override
  Widget build(BuildContext context) {
    int rewardCoins = Provider.of<RewardCoinsProvider>(context).coins;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Store',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 243, 177, 240),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coins Display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: const [
                    Text('0',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 24)),
                    Text('Coins',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 22)),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '$rewardCoins',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 26,
                      ),
                    ),
                    Text('Free Coins',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 22)),
                  ],
                ),
              ],
            ),
            Divider(
              thickness: 5,
              color: const Color.fromARGB(255, 227, 216, 216),
            ),
            // Limited-Time Offers
            const Text(
              'Limited-Time Offers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOfferTile('210 Coins', '+ 50 Free Coins', '\$3.08', '+24%'),
                _buildOfferTile('700 Coins', '+ 700 Free Coins', '\$10.27', '+100%'),
              ],
            ),
            const SizedBox(height: 16),
            // Other Plans
            const Text(
              'Other Plans',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  _buildPlanTile('350 Coins', '+ 300 Free Coins', '\$5.13', '+86%'),
                  _buildPlanTile('1400 Coins', '+ 280 Free Coins', '\$20.54', '+20%'),
                  _buildPlanTile('2100 Coins', '+ 1000 Free Coins', '\$31.27', '+48%'),
                  _buildPlanTile('3500 Coins', '+ 1400 Free Coins', '\$52.30', '+40%'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Payment Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Exchange coins',
                  style: TextStyle(fontSize: 17),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExchangePage(itemId: 'qrcode')),
                    );
                  },
                  child: const Text('No active coupons >'),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 233, 157, 246),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Example: Add 100 coins on payment
                  Provider.of<RewardCoinsProvider>(context, listen: false).addCoins(100);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('You have purchased $selectedPrice!')),
                  );
                },
                child: Text(
                  'Pay $selectedPrice',  
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferTile(String coins, String freeCoins, String price, String bonus) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPrice = price; // Update selected price
        });
      },
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 242, 130, 244).withOpacity(0.1),
          border: Border.all(color: const Color.fromARGB(255, 255, 181, 253)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              coins,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(freeCoins, style: const TextStyle(color: Color.fromARGB(255, 255, 146, 253))),
            const SizedBox(height: 8),
            Text(price, style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 237, 126, 230))),
            Text(bonus, style: const TextStyle(fontSize: 12, color: Color.fromARGB(255, 244, 140, 230))),
          ],
        ),
      ),
    );
  }

  // Plan Tile
  Widget _buildPlanTile(String coins, String freeCoins, String price, String bonus) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPrice = price; // Update selected price
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color.fromARGB(255, 9, 8, 6)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(coins, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(freeCoins, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            Column(
              children: [
                Text(price, style: const TextStyle(fontSize: 16, color: Colors.black)),
                Text(bonus, style: const TextStyle(fontSize: 12, color: Color.fromARGB(255, 245, 167, 254))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}