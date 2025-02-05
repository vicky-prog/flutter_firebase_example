import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';



part 'auth_event.dart';
part 'auth_state.dart';




class AuthBloc extends Bloc<AuthEvent, AuthState> {
 // final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseAuth _auth;
  AuthBloc(this._auth) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<SignupEvent>(_onSignup);
    on<LogoutEvent>(_onLogout);
    on<ToggleAuthModeEvent>(_onToggleAuthMode);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(Authenticated(user: userCredential.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: e.message ?? 'An error occurred')); // Handle null message
       // Reset to initial state after error
      emit(const AuthInitial());
    }
  }

  Future<void> _onSignup(SignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(Authenticated(user: userCredential.user!));
    } on FirebaseAuthException catch (e) {
       emit(AuthError(message: e.message!));
       emit(const AuthInitial());
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await _auth.signOut();
     emit(Unauthenticated());
     emit(AuthInitial());
  }

   void _onToggleAuthMode(ToggleAuthModeEvent event, Emitter<AuthState> emit) {
    if (state is AuthInitial) {
      final currentState = state as AuthInitial;
      emit(AuthInitial(isNewUser: !currentState.isNewUser));
    }
  }
}