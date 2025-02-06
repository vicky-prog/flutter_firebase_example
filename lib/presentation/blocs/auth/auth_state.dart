part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState(this.isNewUser);
  final bool isNewUser;

  @override
  List<Object> get props => [isNewUser];
}

class AuthInitial extends AuthState {
  const AuthInitial(super.isNewUser);

  @override
  List<Object> get props => [isNewUser];
}

class AuthLoading extends AuthState {
  const AuthLoading(super.isNewUser);
}

class Authenticated extends AuthState {
  final User user;

  const Authenticated(super.isNewUser, {required this.user});

  @override
  List<Object> get props => [isNewUser, user];
}

class Unauthenticated extends AuthState {
  const Unauthenticated(super.isNewUser);
}

class AuthError extends AuthState {
  final String message;

  const AuthError(super.isNewUser, {required this.message});

  @override
  List<Object> get props => [isNewUser, message];
}
