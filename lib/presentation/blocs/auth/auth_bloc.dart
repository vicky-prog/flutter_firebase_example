import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth;
  bool _isNewUser = false; // Instance variable

  // Pass initial value directly to AuthInitial in the constructor
  AuthBloc(this._auth) : super(AuthInitial(false)) {
    // Pass false or true based on initial state
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
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(Authenticated(_isNewUser, user: userCredential.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_isNewUser, message: e.message ?? 'An error occurred'));
      // After emitting the error state, trigger the reset state
      add(ResetAuthStateEvent()); // Reset the state through an event
    }
  }

  Future<void> _onSignup(SignupEvent event, Emitter<AuthState> emit) async {
    if (!_validate(event.email, event.password, emit)) return;
    emit(AuthLoading(_isNewUser));
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(Authenticated(_isNewUser, user: userCredential.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_isNewUser, message: e.message!));
      // After emitting the error state, trigger the reset state
      add(ResetAuthStateEvent()); // Reset the state through an event
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await _auth.signOut();
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

    // Basic email format validation
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      emit(AuthError(_isNewUser, message: "Invalid email format"));
      // After emitting the error state, trigger the reset state
      add(ResetAuthStateEvent()); // Reset the state through an event
      return false;
    }

    // Password length validation
    if (password.length < 6) {
      emit(AuthError(_isNewUser,
          message: "Password must be at least 6 characters long"));
      // After emitting the error state, trigger the reset state
      add(ResetAuthStateEvent()); // Reset the state through an event
      return false;
    }

    return true;
  }
}
