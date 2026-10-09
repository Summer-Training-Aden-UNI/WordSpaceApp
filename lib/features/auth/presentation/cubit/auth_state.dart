part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState { const AuthInitial(); }          // checking saved token
final class AuthUnauthenticated extends AuthState { const AuthUnauthenticated(); } // show Welcome
final class AuthGuest extends AuthState { const AuthGuest(); }

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);
  final User user;
  @override
  List<Object?> get props => [user];
}