import 'package:flutter/material.dart';

class ExplorerPage extends StatelessWidget {
  const ExplorerPage ({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Explorer Page'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/icons/istockphoto-855413388-612x612.jpg', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Content stacked on top of the image
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 60), // Spacing from top
                  // Header
                  Text(
                    'Be An Explorer in Tourist Trail',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 2, 2, 2),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  // Subheader
                  Text(
                    'Let the world hear your story.\nWe are trying to get more explorers!',
                    style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(179, 0, 0, 0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                  // Content Box
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'For exclusive writers',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 242, 244, 249),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '• Access to the pay-to-explore project and a steady royalty income monthly',
                          style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '• Exclusive Signing Fee & Bonus (up to \$xxx in total)',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}