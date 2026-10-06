import 'package:equatable/equatable.dart';

/// What the API exposes publicly about a user (PublicUserResource).
class PublicUser extends Equatable {
  final int id;
  final String name;
  final String? username;

  const PublicUser({required this.id, required this.name, this.username});

  @override
  List<Object?> get props => [id, name, username];
}
