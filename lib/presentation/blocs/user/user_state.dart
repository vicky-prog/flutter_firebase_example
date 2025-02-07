part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserAdded extends UserState {}

class UserError extends UserState {
  final String message;

  const UserError(this.message);
}
