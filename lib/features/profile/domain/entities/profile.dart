import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final int id;
  final String name;
  final String? username;
  final String? email;
  final String? bio;
  final String? avatarUrl;

  const Profile({
    required this.id,
    required this.name,
    this.username,
    this.email,
    this.bio,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, name, username, email, bio, avatarUrl];
}
