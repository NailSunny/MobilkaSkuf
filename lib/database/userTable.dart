import 'package:supabase_flutter/supabase_flutter.dart';

class Usertable {
  final Supabase _supabase = Supabase.instance;

  Future<void> addUser(String name, String email, String password) async {
    try {
      await _supabase.client.from('users').insert({
        'username': name, 
        'email': email,
        'password': password,
        'photo': 'https://ztrjqqmeduxbamylhfjf.supabase.co/storage/v1/object/public/storages//default_person.jpg'
      });
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void>updateUser(String url, String desc, dynamic uid) async {
    try {
      await _supabase.client.from('users').update({
        'photo': url,
        'description': desc
      }).eq('id', uid);
    }
    catch (e) {
      return;
    }
  }
}
