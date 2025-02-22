import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageMethods {
  final supabase = Supabase.instance.client;

  Future<String?> uploadImage(
    BuildContext context, String childName, Uint8List file) async {
      try {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
        final path = 'uploads/$childName/$fileName';

        await supabase.storage.from('images').uploadBinary(path, file);
        final imageUrl = supabase.storage.from('images').getPublicUrl(path);

        // Delay the Snackbar execution until the next frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image uploaded successfully')),
            );
          }
        });

        return imageUrl;
      } catch (e) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Upload failed: $e')),
            );
          }
        });
        return null;
      }
    }

}
