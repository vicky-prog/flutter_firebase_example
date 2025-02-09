import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_example/presentation/core/utils/validators.dart';
import 'package:flutter_firebase_example/domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository; 
  bool _isNewUser = false; // Instance variable

  // Pass initial value directly to AuthInitial in the constructor
  AuthBloc(this._authRepository) : super(AuthInitial(false)) {
    on<LoginEvent>(_onLogin);
    on<SignupEvent>(_onSignup);
    on<LogoutEvent>(_onLogout);
    on<ToggleAuthModeEvent>(_onToggleAuthMode);
    on<ResetAuthStateEvent>(_reset);
  }

 Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
  if (!_validate(event.email, event.password, emit)) return;
  emit(AuthLoading(_isNewUser));
  try {
    UserCredential userCredential = await _authRepository.login(
      email: event.email,
      password: event.password,
    );
    emit(Authenticated(_isNewUser, user: userCredential.user!));
  } catch (e) {
     emit(AuthError(_isNewUser, message: e.toString() ));
      // After emitting the error state, trigger the reset state
      add(ResetAuthStateEvent()); // Reset the state through an event
  }
}


  Future<void> _onSignup(SignupEvent event, Emitter<AuthState> emit) async {
    if (!_validate(event.email, event.password, emit)) return;
    emit(AuthLoading(_isNewUser));
    try {
      UserCredential userCredential =
          await _authRepository.signup(
        email: event.email,
        password: event.password,
      );
      emit(Authenticated(_isNewUser, user: userCredential.user!));
    }  catch (e) {
      emit(AuthError(_isNewUser, message: e.toString()));
      // After emitting the error state, trigger the reset state
      add(ResetAuthStateEvent()); // Reset the state through an event
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await _authRepository.logout();
    emit(Unauthenticated(_isNewUser)); // Pass _isNewUser here as well.
    // After emitting the error state, trigger the reset state
    add(ResetAuthStateEvent()); // Reset the state through an event
  }

  void _onToggleAuthMode(ToggleAuthModeEvent event, Emitter<AuthState> emit) {
    if (state is AuthInitial) {
      final currentState = state as AuthInitial;
      _isNewUser = !currentState.isNewUser;
      emit(AuthInitial(_isNewUser)); // Toggle new user status
    }
  }

  void _reset(ResetAuthStateEvent event, Emitter<AuthState> emit) {
    emit(AuthInitial(
        _isNewUser)); // Ensure the current value of _isNewUser is passed.
  }

  bool _validate(String email, String password, Emitter<AuthState> emit) {
    if (email.isEmpty || password.isEmpty) {
      emit(AuthError(_isNewUser,
          message: "Email and password must not be empty"));
      // After emitting the error state, trigger the reset state
      add(ResetAuthStateEvent()); // Reset the state through an event
      return false;
    }

    
    if (!validateEmail(email)) {
      emit(AuthError(_isNewUser, message: "Invalid email format"));
      // After emitting the error state, trigger the reset state
      add(ResetAuthStateEvent()); // Reset the state through an event
      return false;
    }

    // Password length validation
    if (!validatePassword(password)) {
      emit(AuthError(_isNewUser,
          message: "Password must be at least 6 characters long"));
      // After emitting the error state, trigger the reset state
      add(ResetAuthStateEvent()); // Reset the state through an event
      return false;
    }

    return true;
  }
}
