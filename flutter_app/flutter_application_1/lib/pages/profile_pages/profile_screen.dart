import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/pages/search_pages/follow_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../shop_pages/store_page.dart';
import 'membership.dart';
import 'settings_page.dart';
import 'help_center.dart';
import 'inbox_page.dart';
import 'viewed_page.dart';
import 'pocket_page.dart';
import 'checkin_page.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfilePageState();
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

class _ProfilePageState extends State<ProfileScreen> {
  var userData = {};
  int rewardCoins = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = userSnap.data()!;
      rewardCoins = userData['coins'];
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> updateCoins(int coins) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'coins': coins});
      setState(() {
        rewardCoins = coins;
      });
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 239, 216, 238),
            appBar: AppBar(
              title: Text(
                'Wander Sphere',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 27,
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              elevation: 0.0,
              backgroundColor: const Color.fromARGB(255, 240, 157, 249),
              actions: [
                GestureDetector(
                  onTap: () {
                    // Example user data (replace with your actual user data)
                    String userEmail =
                        userData['email']; // Replace with actual user email
                    String userId = FirebaseAuth.instance.currentUser!
                        .uid; // Replace with actual user ID

                    // Show the dialog with user email and ID
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Row(
                            children: [
                              Icon(Icons.person, color: Colors.purple),
                              SizedBox(width: 8),
                              Text(
                                "User Info",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                ),
                              ),
                            ],
                          ),
                          content: Container(
                            width: 400, // Set the width of the dialog
                            height: 400,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildUserInfoRow("Email", userEmail),
                                  _buildDivider(),
                                  _buildUserInfoRow("User ID", userId),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text(
                                "Close",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 47,
                    height: 30,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 244, 149, 255),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    )
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                            userData['photoUrl'],
                          ),
                          radius: 40,
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData['username'],
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      width: 500,
                      height: 200,
                      margin: EdgeInsets.only(top: 8, left: 13, right: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: const Color.fromARGB(255, 20, 214, 146)),
                      ),
                      child: Stack(
                        children: [
                          // First Column
                          Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Text(
                                  'Balance: $rewardCoins coins',
                                  style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 20, 214, 146),
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const StorePage()),
                                          );
                                        },
                                        child: Text(
                                          'TOP UP',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Positioned Second Padding at the Bottom
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                width: 10,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 15),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color.fromARGB(255, 222, 156, 230),
                                      const Color.fromARGB(255, 150, 4, 145)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MembershipPage()),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4), // Adjust padding
                                        textStyle: TextStyle(
                                            fontSize: 15), // Smaller font size
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10), // Rounded edges
                                        ),
                                      ),
                                      child: Text(
                                        'Go VIP',
                                        style: TextStyle(
                                            fontSize:
                                                14), // Match font size with button
                                      ),
                                    ),
                                    SizedBox(width: 0.5),
                                    SvgPicture.asset(
                                      'assets/icons/vip-svgrepo-com.svg',
                                      width: 24,
                                      height: 24,
                                    ),
                                    SizedBox(width: 0.5),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Get coins and coupons daily',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: const Color.fromARGB(
                                                    255, 0, 0, 0))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 0.6),
                  //now i'm gonn set the format of a hole container through the padding
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      margin: EdgeInsets.only(top: 8, left: 13, right: 13),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 217, 247),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: const Color.fromARGB(255, 192, 43, 229)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff1D1617).withOpacity(0.14),
                            blurRadius: 70,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      //finished setting,now i'll define each ListTile and its caracteristics
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.card_giftcard),
                            title: Text('Earn Rewards',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            trailing: Text('Check in',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      const Color.fromARGB(255, 22, 108, 179),
                                  fontWeight: FontWeight.bold,
                                )),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CheckInPage(
                                      updateCoins: updateCoins,
                                      currentCoins: rewardCoins,
                                    )),
                              );
                            },
                          ),
                          Divider(
                            thickness: 1, // Set the thickness of the divider
                            color: const Color.fromARGB(
                                255, 0, 0, 0), // Set the color of the divider
                          ),
                          ListTile(
                            leading: Icon(Icons.folder),
                            title: Text('Pocket',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PocketPage()),
                              );
                            },
                          ),
                          Divider(
                            thickness: 1,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          ListTile(
                            leading: Icon(Icons.access_time),
                            title: Text('Viewed',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ViewedPage()),
                              );
                            },
                          ),
                          Divider(
                            thickness: 1,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          ListTile(
                            leading: Icon(Icons.message),
                            title: Text('Inbox',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const InboxPage()),
                              );
                            },
                          ),
                          Divider(
                            thickness: 1,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          ListTile(
                            leading: Icon(Icons.map),
                            title: Text('My Posts',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FollowPage(uid: widget.uid)),
                              );
                            },
                          ),
                          Divider(
                            thickness: 1,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          ListTile(
                            leading: Icon(Icons.help_center),
                            title: Text('Help Center',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const HelpCenterPage()),
                              );
                            },
                          ),
                          Divider(
                            thickness: 1,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          ListTile(
                            leading: Icon(Icons.settings),
                            title: Text('Setting',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SettingsPage()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildUserInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      thickness: 2,
      color: const Color.fromARGB(255, 227, 216, 216),
    );
  }
}