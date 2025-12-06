import 'package:flutter/material.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage ({super.key});
  @override
  _HelpCenterPageState createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  bool _isAccountExpanded = false;
  bool _isBooksExpanded = false;
  bool _isCoinsExpanded = false;
  bool _isOthersExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 237, 216, 239),
      appBar: AppBar(
        title: Text('Help Center', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor:const Color.fromARGB(255, 214, 161, 220),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildExpandableTile(
              title: "Account",
              expanded: _isAccountExpanded,
              onTap: () {
                setState(() {
                  _isAccountExpanded = !_isAccountExpanded;
                });
              },
              content: Column(
                children: [
                  _buildContentTile("how can i log in/log out?"),
                  _buildContentTile("how can i find my user ID"),
                  _buildContentTile("will my coins still exist when i change the device?"),
                  _buildContentTile("how can i delete my accont?"),
                ],
              ),
            ),
            _buildExpandableTile(
              title: "Maps",
              expanded: _isBooksExpanded,
              onTap: () {
                setState(() {
                  _isBooksExpanded = !_isBooksExpanded;
                });
              },
              content: Column(
                children: [
                  _buildContentTile("How to explore new places?"),
                  _buildContentTile("does it count when i explore the same place twice?"),
                ],
              ),
            ),
            _buildExpandableTile(
              title: "Coins & Free Coins",
              expanded: _isCoinsExpanded,
              onTap: () {
                setState(() {
                  _isCoinsExpanded = !_isCoinsExpanded;
                });
              },
              content: Column(
                children: [
                  _buildContentTile("What's the difference between Coins and Free Coins?"),
                  _buildContentTile("How to get Free Coins?"),
                  _buildContentTile("Why have my Free Coins disappeared?"),
                  _buildContentTile("Why my Free Coins/Coins are deducted twice?"),
                  _buildContentTile("When will the Coins I purchased arrive?"),
                  _buildContentTile("How to use Free Coins, especially those Exclusive Free Coins?"),
                ],
              ),
            ),
            _buildExpandableTile(
              title: "Others",
              expanded: _isOthersExpanded,
              onTap: () {
                setState(() {
                  _isOthersExpanded = !_isOthersExpanded;
                });
              },
              content: Column(
                children: [
                  _buildContentTile("How to contact customer support?"),
                  _buildContentTile("can't I watch the ads?"),
                  _buildContentTile("how to check your current version?"),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                   foregroundColor:const Color.fromARGB(255, 89, 99, 183),
                 shadowColor: const Color.fromARGB(255, 89, 99, 183),
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                // Contact Us action
              },
              child: Text("Contact us", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableTile({
    required String title,
    required bool expanded,
    required Function onTap,
    required Widget content,
  }) {
    return ExpansionTile(
      title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      leading: Icon(expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
      children: [content],
      onExpansionChanged: (bool value) {
        onTap();
      },
    );
  }

  Widget _buildContentTile(String text) {
    return ListTile(
      title: Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      leading: Icon(Icons.arrow_forward_ios, size: 17),
      onTap: (){
        
      },
    );
  }
}