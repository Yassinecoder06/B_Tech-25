import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/services/auth_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notifications = true;
  bool showRecentReads = true;
  bool autoUnlock = false;
  bool autoAddToLibrary = true;
  void _signOut(BuildContext context) async {
    final bool? confirmSignOut = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );

    if (confirmSignOut == true) {
      await FirebaseAuth.instance.signOut();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AuthPage(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 214, 161, 220),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SwitchListTile(
              title: Text(
                "Notifications",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              value: notifications,
              onChanged: (bool value) {
                setState(() {
                  notifications = value;
                });
              },
              activeColor: Colors.green,
            ),
            SwitchListTile(
              title: Text(
                "Show recent visited places",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              value: showRecentReads,
              onChanged: (bool value) {
                setState(() {
                  showRecentReads = value;
                });
              },
              activeColor: Colors.green,
            ),
            SwitchListTile(
              title: Text(
                "Auto Unlock",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              value: autoUnlock,
              onChanged: (bool value) {
                setState(() {
                  autoUnlock = value;
                });
              },
              activeColor: Colors.green,
            ),
            SwitchListTile(
              title: Text(
                "Auto Add to Library",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              value: autoAddToLibrary,
              onChanged: (bool value) {
                setState(() {
                  autoAddToLibrary = value;
                });
              },
              activeColor: Colors.green,
            ),
            Divider(),
            ListTile(
              title: Text(
                "travelling Preference",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                "Language",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                "English",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                "Age Restrictions",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                "15+ ig",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                "Privacy Settings",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                "About",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                "Delete Account",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showDeleteAccountDialog(context);
              },
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 89, 99, 183),
                  shadowColor: const Color.fromARGB(255, 89, 99, 183),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  _signOut(context);
                },
                child: Text("Sign Out",
                    style:
                        TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 8),
              Text(
                "Delete Account",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          content: const Text(
            "Are you sure you want to delete your account? This action cannot be undone.",
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                    color: Color.fromARGB(255, 134, 133, 133), fontSize: 17),
              ),
            ),
            TextButton(
              onPressed: () {
                // Add your account deletion logic here
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red, fontSize: 17),
              ),
            ),
          ],
        );
      },
    );
  }
}
