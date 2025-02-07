import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_firebase_example/domain/entities/user_entity.dart';
import 'package:flutter_firebase_example/domain/repositories/user_repository.dart';
import 'package:flutter_firebase_example/domain/usecases/add_user_usecase.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {

   final AddUserUseCase _addUserUseCase;
  UserBloc(this._addUserUseCase) : super(UserInitial()) {
   on<AddUserEvent>(_onAddUser);
  }

Future<void> _onAddUser(AddUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await _addUserUseCase(event.user);
      emit(UserAdded());
    } catch (e) {
      emit(UserError("Failed to add user: ${e.toString()}"));
    }
  }
}
