import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mess_scuf/database/storage/image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String user = Supabase.instance.client.auth.currentUser!.id.toString();
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _password = '';
  String? _photoUrl;
  Uint8List? _selectedImage;
  bool _isLoading = false;

  Future<void> _uploadImage() async {
    setState(() => _isLoading = true);

    try {
      // 1. Выбираем фото
      final imageBytes = await ImageHandler.getPhoto(context);
      if (imageBytes == null) return;

      // 2. Загружаем и получаем URL
      final url = await ImageHandler.uploadImage(imageBytes, context);
      if (url == null) return;

      setState(() {
        _selectedImage = imageBytes;
        _photoUrl = url;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      // Обновляем данные пользователя
      await Supabase.instance.client.from('users').update({
        'username': _name,
        'password': _password,
        if (_photoUrl != null) 'photo': _photoUrl,
      }).eq('id', user);

      // Обновляем аутентификационные данные
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: _password),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Профиль обновлен')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getUserData() async {
    try {
      final userDoc = await Supabase.instance.client
          .from('users')
          .select()
          .eq('id', user)
          .single();

      setState(() {
        _name = userDoc['username'] ?? '';
        _password = userDoc['password'] ?? '';
        _photoUrl = userDoc['photo'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки данных: ${e.toString()}')),
      );
    }
  }

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать профиль'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.popAndPushNamed(context, '/chats'),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _selectedImage != null
                              ? MemoryImage(_selectedImage!)
                              : (_photoUrl != null
                                  ? NetworkImage(_photoUrl!)
                                  : null),
                          child: _photoUrl == null && _selectedImage == null
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.add, size: 20),
                          ),
                          onPressed: _uploadImage,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      initialValue: _name,
                      decoration: const InputDecoration(
                        labelText: 'Имя пользователя',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Введите имя пользователя'
                          : null,
                      onSaved: (value) => _name = value!,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Пароль',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Введите пароль' : null,
                      onSaved: (value) => _password = value!,
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: _saveProfile,
                      child: const Text('Сохранить изменения'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
