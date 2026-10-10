import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/register.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required Login login,
    required Register register,
    required Logout logout,
    required GetCurrentUser getCurrentUser,
    required TokenStorage tokenStorage,
  }) : _login = login,
       _register = register,
       _logout = logout,
       _getCurrentUser = getCurrentUser,
       _tokenStorage = tokenStorage,
       super(const AuthInitial());

  final Login _login;
  final Register _register;
  final Logout _logout;
  final GetCurrentUser _getCurrentUser;
  final TokenStorage _tokenStorage;

  /// Call once at app start.
  Future<void> checkSession() async {
    final token = await _tokenStorage.read();
    if (token == null) return emit(const AuthUnauthenticated());

    final result = await _getCurrentUser(const NoParams());
    if (isClosed) return;
    result.fold(
      (_) => emit(const AuthUnauthenticated()),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  /// Returns null on success, or the Failure so the page can show it.
  Future<Failure?> login(String email, String password) async {
    final result = await _login(LoginParams(email: email, password: password));
    if (isClosed) return null;
    return result.fold<Failure?>((f) => f, (user) {
      emit(AuthAuthenticated(user));
      refreshUser();
      return null;
    });
  }

  Future<Failure?> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String username,
  }) async {
    final result = await _register(
      RegisterParams(
        name: name,
        email: email,
        username: username,
        password: password,
        passwordConfirmation: passwordConfirmation,
      ),
    );
    if (isClosed) return null;
    return result.fold<Failure?>((f) => f, (user) {
      emit(AuthAuthenticated(user));
      refreshUser();
      return null;
    });
  }

  Future<void> logout() async {
    await _logout(const NoParams());
    if (!isClosed) emit(const AuthUnauthenticated());
  }

  void continueAsGuest() => emit(const AuthGuest());
  /// After "Edit profile": keeps the signed-in user in step with the server
  /// (no API call). [avatarUrl] is the saved photo, or null if removed.
  void updateUser({
    required String name,
    String? username,
    String? avatarUrl,
  }) {
    final s = state;
    if (s is! AuthAuthenticated) return;

    emit(
      AuthAuthenticated(
        User(
          id: s.user.id,
          name: name,
          username: username ?? s.user.username,
          email: s.user.email,
          avatarUrl: avatarUrl,
        ),
      ),
    );
  }

  /// Reloads the signed-in user from GET /user (adds the avatar URL).
  Future<void> refreshUser() async {
    if (state is! AuthAuthenticated) return;
    final result = await _getCurrentUser(const NoParams());
    if (isClosed || state is! AuthAuthenticated) return;
    result.fold((_) {}, (user) => emit(AuthAuthenticated(user)));
  }
  /// A guest wants to sign in: back to the Welcome screen.
  void leaveGuest() {
    if (state is AuthGuest) emit(const AuthUnauthenticated());
  }

  /// Called by DioClient after a 401. Only matters for a logged-in user.
  void sessionExpired() {
    if (state is AuthAuthenticated) emit(const AuthUnauthenticated());
  }
}
