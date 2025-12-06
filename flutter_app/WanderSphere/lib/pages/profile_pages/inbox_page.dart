import 'package:flutter/material.dart';
import 'package:flutter_application_1/styles/scroll_decorator.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  final List<String> messages = List.generate(20, (index) => 'Message ${index + 1}');
  final TextEditingController _searchController = TextEditingController();
  List<String> filteredMessages=[];

  @override
  void initState() {
    super.initState();
    filteredMessages = messages;
  }

  void _filterMessages(String query) {
    setState(() {
      filteredMessages = messages
          .where((message) => message.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _refreshMessages() async {
    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      messages.shuffle(); // Example: shuffle messages
      filteredMessages = messages;
    });
  }

    void _showDeleteAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 8),
              Text(
                "Delete All",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          content: const Text(
            "Are you sure you want to delete all messsages? This action cannot be undone.",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Color.fromARGB(255, 134, 133, 133), fontSize: 17),
              ),
            ),
            TextButton(
              onPressed: () {
                 _deleteAllItems();
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

void _deleteAllItems() {
    setState(() {
      messages.clear();
      messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inbox", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 202, 161, 206),
                        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Color.fromARGB(255, 126, 25, 149)),
            onPressed: () {
              _showDeleteAllDialog(context);
            },
          ),
        ],
      ),
      body: ScrollDecorator(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: _filterMessages,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshMessages,
                child: ListView.builder(
                  itemCount: filteredMessages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.mail),
                      title: Text(filteredMessages[index], style: const TextStyle(fontSize: 20)),
                      subtitle: const Text('This is the message preview', style: TextStyle(fontSize: 17)),
                      onTap: () {
                        // Handle message tap
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}