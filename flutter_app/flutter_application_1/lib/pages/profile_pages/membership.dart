import 'package:flutter/material.dart';
import 'history_page.dart';
class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key});

  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  bool isAgreementChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 212, 196, 196),
      appBar: AppBar(
        title: const Text("Membership"),
        backgroundColor: const Color.fromARGB(255, 222, 119, 82),
        actions: [
          IconButton(
            onPressed: () {
                Navigator.push(
                          context,
                            MaterialPageRoute(builder: (context) => const HistoryPage()),
                            );
              // Navigate to History Page or any relevant action
            },
            icon: const Icon(Icons.history,size: 30,color: Colors.black,),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // VIP Monthly Section
            _buildVipMonthlySection(),
            const SizedBox(height: 16),
            // Only for VIPs Section
            const Text(
              "Only for VIPs",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 8),
            _buildVipFeatures(),
            const SizedBox(height: 16),
            // VIP Plans
            _buildVipPlans(),
            const SizedBox(height: 8),
            // Checkbox Agreement
            _buildAgreementCheckbox(),
          ],
        ),
      ),
      // BottomAppBar for the subscription button
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 225, 164, 110),
              minimumSize: const Size(double.infinity, 70),
            ),
            onPressed: isAgreementChecked
                ? () {
                    // Perform subscription logic
                  }
                : null,
            child: const Text(
              "Subscribe now",
              style: TextStyle(fontSize: 17),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVipMonthlySection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFE0BD), Color.fromARGB(255, 121, 74, 32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color.fromARGB(255, 255, 213, 129)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "VIP Monthly",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Get Coins, Free Coins and Coupons daily",
            style: TextStyle(fontSize: 17, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Navigate to perks details
              },
              child: const Text(
                "Check perks >",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVipFeatures() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 3.5,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: [
        _buildVipFeatureTile("Subscribe for more Coins", Icons.monetization_on,
            const Color.fromARGB(255, 230, 180, 18)),
        _buildVipFeatureTile("Check-in daily for Free Coins", Icons.check_circle,
            const Color.fromARGB(255, 2, 168, 2)),
        _buildVipFeatureTile(
            "Get a Discount Coupon weekly",
            Icons.card_giftcard,
            const Color.fromARGB(255, 215, 21, 21)),
        _buildVipFeatureTile("Ad-free Lucky draw", Icons.emoji_events,
            const Color.fromARGB(255, 232, 60, 88)),
      ],
    );
  }

  Widget _buildVipPlans() {
    return Column(
      children: [
        _buildPlanTile("1785 Total", "700 Coins", "1085 Free Coins", "\$9.99",
            "VIP Monthly",  const Color.fromARGB(255, 230, 180, 18)),
        _buildPlanTile("4900 Total", "1750 Coins", "3150 Free Coins", "\$24.99",
            "VIP Quarterly", Colors.red),
        _buildPlanTile("18025 Total", "6300 Coins", "11725 Free Coins", "\$79.99",
            "VIP Annual", Colors.blue),
      ],
    );
  }

  Widget _buildAgreementCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: isAgreementChecked,
          onChanged: (value) {
            setState(() {
              isAgreementChecked = value!;
            });
          },
        ),
        const Expanded(
          child: Text(
            "Confirmed and agreed to the Tourist Trail Subscription Service Agreement",
            style: TextStyle(
              fontSize: 17,
              color: Color.fromARGB(134, 51, 49, 49),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVipFeatureTile(String title, IconData icon, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Icon(icon, color: iconColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white,fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanTile(String total, String coins, String freeCoins,
      String price, String planType, Color tagColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                total,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                coins,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              Text(
                freeCoins,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AnimatedContainer(
                duration: const Duration(seconds: 2),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tagColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  planType,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                price,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
