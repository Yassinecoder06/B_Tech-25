import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/reward_coins_provider.dart';

class CheckInPage extends StatefulWidget {
  final Function updateCoins;
  final int currentCoins;
  const CheckInPage({required this.updateCoins, required this.currentCoins, super.key});

  @override
  _CheckInPageState createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  int rewardPoints = 0;
  int adsWatched = 0;
  int placesUnlocked = 0;
  int weeklyChallengesCompleted = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      setState(() {
        rewardPoints = userSnap.data()!['coins'];
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> updateCoins(int coins) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'coins': coins});
      setState(() {
        rewardPoints = coins;
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void _watchAd() {
    setState(() {
      adsWatched += 1;
      rewardPoints += 5; // Example reward points for watching an ad
    });
    updateCoins(rewardPoints);
    Provider.of<RewardCoinsProvider>(context, listen: false).addCoins(5);
  }

  void _unlockPlace() {
    setState(() {
      placesUnlocked += 1;
      rewardPoints += 15; // Example reward points for unlocking a place
    });
    updateCoins(rewardPoints);
    Provider.of<RewardCoinsProvider>(context, listen: false).addCoins(15);
  }

  void _completeWeeklyChallenge() {
    setState(() {
      weeklyChallengesCompleted += 1;
      rewardPoints += 20; // Example reward points for completing a weekly challenge
    });
    updateCoins(rewardPoints);
    Provider.of<RewardCoinsProvider>(context, listen: false).addCoins(20);
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check-In Rewards"),
        backgroundColor: const Color.fromARGB(255, 202, 137, 209),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reward Coins: $rewardPoints',
                style: const TextStyle(
                    color: Color.fromARGB(255, 94, 107, 211),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color.fromARGB(255, 97, 148, 236)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Watch Ads',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: adsWatched / 10, // Example progress
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _watchAd,
                      child: const Text(
                        'Watch Ad',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color.fromARGB(255, 70, 200, 61)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Unlock Places',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: placesUnlocked / 10, // Example progress
                      backgroundColor: Colors.grey[300],
                      color: Colors.green,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _unlockPlace,
                      child: const Text(
                        'Unlock Place',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color.fromARGB(255, 252, 194, 114)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weekly Challenges',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: weeklyChallengesCompleted / 5, // Example progress
                      backgroundColor: Colors.grey[300],
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _completeWeeklyChallenge,
                      child: const Text(
                        'Complete Weekly Challenge',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
  }
}