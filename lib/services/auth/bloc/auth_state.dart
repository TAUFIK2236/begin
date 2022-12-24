
import 'package:equatable/equatable.dart';
import 'package:untitled/services/auth/auth_user.dart';

abstract class AuthState {
  const AuthState();
}

class AuthStateUninitialized extends AuthState {
  AuthStateUninitialized();
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;

  AuthStateRegistering(this.exception);
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

class AuthStateLoggedOut extends AuthState with EquatableMixin{
  final Exception? exception;
  final bool isLoading;
  const AuthStateLoggedOut({
    required this.exception,
    required this.isLoading,
  });

  @override

  List<Object?> get props =>[exception,isLoading,];
}

// class AuthStateLogOutFailure extends AuthState{
//   final Exception exception;
//   const AuthStateLogOutFailure(this.exception);
// }
