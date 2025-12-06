import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/reward_coins_provider.dart';

class ExchangePage extends StatefulWidget {
  final String itemId;
  const ExchangePage({super.key, required this.itemId});

  @override
  _ExchangePageState createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {
  bool _showQrCode = false;

 void _showQrCodeDialog() {
  print('Showing QR Code Dialog'); // Debugging
  setState(() {
    _showQrCode = true;
  });
}

  void _hideQrCodeDialog() {
    setState(() {
      _showQrCode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Exchange Coins'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 238, 152, 247),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(child: FittedBox(child: Text('Coupons'))),
              Tab(child: FittedBox(child: Text('Discounts'))),
              Tab(child: FittedBox(child: Text('Accommodations'))),
              Tab(child: FittedBox(child: Text('Food'))),
            ],
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<RewardCoinsProvider>(
                    builder: (context, rewardCoinsProvider, child) {
                      return Text(
                        'Your Balance: ${rewardCoinsProvider.coins} coins',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Spend your coins on the following items:',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildCategory(context, 'Coupon', [
                          {'name': 'Coupon 1', 'cost': 50},
                          {'name': 'Coupon 2', 'cost': 100},
                        ]),
                        _buildCategory(context, 'Discount', [
                          {'name': 'Discount 1', 'cost': 100},
                          {'name': 'Discount 2', 'cost': 200},
                        ]),
                        _buildCategory(context, 'Accommodation', [
                          {'name': 'Accommodation 1', 'cost': 150},
                          {'name': 'Accommodation 2', 'cost': 300},
                        ]),
                        _buildCategory(context, 'Food', [
                          {'name': 'Food 1', 'cost': 200},
                          {'name': 'Food 2', 'cost': 400},
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // QR Code Dialog Overlay
            Visibility(
              visible: _showQrCode,
              child: Center(
                child: Container(
                  color: Colors.black54,
                  child: AlertDialog(
                    title: const Text('Purchase Successful'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('You have purchased the item!'),
                        const SizedBox(height: 20),
                        Image.asset(
                          'qr.png', 
                          width: 300,
                          height: 300,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: _hideQrCodeDialog,
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory(BuildContext context, String category, List<Map<String, dynamic>> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildItem(context, item['name'], item['cost'], category);
      },
    );
  }

  Widget _buildItem(BuildContext context, String itemName, int cost, String category) {
    final rewardCoinsProvider = Provider.of<RewardCoinsProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(itemName),
        subtitle: Text('Cost: $cost coins'),
        trailing: ElevatedButton(
          onPressed: rewardCoinsProvider.coins >= cost
              ? () async {
                  await rewardCoinsProvider.spendCoins(cost);
                  await rewardCoinsProvider.addPurchasedItem(itemName, category, cost);
                  if (!context.mounted) return;
                  _showQrCodeDialog(); // Show QR code dialog
                }
              : null,
          child: const Text('Buy'),
        ),
      ),
    );
  }
}