import 'package:hive/hive.dart';

part 'user_model.g.dart'; // Jangan lupa untuk menambahkan file ini untuk Hive adapter

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String password;

  User({required this.username, required this.password, required String email});
}
