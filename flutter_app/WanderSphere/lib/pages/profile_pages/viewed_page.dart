import 'package:flutter/material.dart';
import 'package:flutter_application_1/styles/scroll_decorator.dart';
class ViewedPage extends StatefulWidget {
  const ViewedPage({super.key});

  @override
  _ViewedPageState createState() => _ViewedPageState();
}

class _ViewedPageState extends State<ViewedPage> {
  final List<String> viewedItems = List.generate(30, (index) => 'Viewed Item ${index + 1}');
  final TextEditingController _searchController = TextEditingController();
  List<String> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = viewedItems;
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = viewedItems
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _refreshItems() async {
    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      viewedItems.shuffle(); // Example: shuffle items
      filteredItems = viewedItems;
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
            "Are you sure you want to delete all viewed items? This action cannot be undone.",
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
      viewedItems.clear();
      filteredItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Viewed Items", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 24)),
        backgroundColor: const Color.fromARGB(255, 202, 137, 209),
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
                onChanged: _filterItems,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshItems,
                child: ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.visibility),
                      title: Text(filteredItems[index], style: const TextStyle(fontSize: 20)),
                      subtitle: const Text('This is a viewed item', style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
                      onTap: () {
                        // Handle item tap
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
