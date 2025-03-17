// image_handler.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageHandler {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<Uint8List?> getPhoto(BuildContext context) async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        return await pickedFile.readAsBytes();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка выбора изображения: ${e.toString()}')),
      );
    }
    return null;
  }

  static Future<String?> uploadImage(
      Uint8List imageBytes, BuildContext context) async {
    try {
      final path = DateTime.now().millisecondsSinceEpoch.toString();
      await _supabase.storage
          .from('storages')
          .uploadBinary(
            path,
            imageBytes,
            fileOptions: FileOptions(
              contentType: 'image/jpeg',
              upsert: true,
            ),
          );

      return _supabase.storage
          .from('storages')
          .getPublicUrl(path);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки: ${e.toString()}')),
      );
      return null;
    }
  }
}
