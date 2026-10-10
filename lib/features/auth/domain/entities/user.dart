import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String username;
  final String email;

  /// Full URL of the profile photo (null when there is none).
  final String? avatarUrl;

  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, name, username, email, avatarUrl];
}