import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPhotoPage extends StatefulWidget {
  const AddPhotoPage({super.key});

  @override
  State<AddPhotoPage> createState() => _AddPhotoPageState();
}

class _AddPhotoPageState extends State<AddPhotoPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  Uint8List? _imageBytes;
  String _path = '';
  String _url = '';

  Future<void> _getPhoto() async {
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      // Для веба можно использовать web только с ImageSource.gallery
      preferredCameraDevice: CameraDevice.rear,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _upload() async {
    if (_imageBytes == null) return;

    try {
      _path = DateTime.now().millisecondsSinceEpoch.toString();
      await supabase.storage
          .from('storages')
          .uploadBinary(
            _path,
            _imageBytes!,
            fileOptions: FileOptions(
              contentType: 'image/jpeg',
              upsert: true,
            ),
          )
          .then((_) => print('Upload complete'));
    } catch (e) {
      print('Upload error: $e');
    }
  }

  Future<void> _downloadUrl() async {
    try {
      final response = supabase.storage.from('storages').getPublicUrl(_path);

      setState(() {
        _url = response;
      });
    } catch (e) {
      print('Download error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Add Photo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _getPhoto,
              child: const Text('Select Photo'),
            ),
            if (_imageBytes != null)
              Container(
                margin: const EdgeInsets.all(20),
                child: Image.memory(_imageBytes!),
              ),
            ElevatedButton(
              onPressed: _upload,
              child: const Text('Upload'),
            ),
            ElevatedButton(
              onPressed: _downloadUrl,
              child: const Text('Get URL'),
            ),
            if (_url.isNotEmpty)
              Container(
                margin: const EdgeInsets.all(20),
                child: Image.network(_url),
              ),
          ],
        ),
      ),
    );
  }
}
