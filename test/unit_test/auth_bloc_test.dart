import 'package:flutter_firebase_example/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class TestConstants {
  static const validEmail = 'test@example.com';
  static const validPassword = 'password123';
  static const invalidEmail = 'wrong@example.com';
  static const invalidPassword = 'wrongpassword';
  static const userNotFoundErrorCode = 'user-not-found';
  static const userNotFoundErrorMessage = 'user-not-found';
}


void main() {
  late AuthBloc authBloc;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    authBloc = AuthBloc(mockFirebaseAuth);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc Tests', () {
    test('initial state is AuthInitial', () {
      expect(authBloc.state, equals(AuthInitial(false))); // Ensure initial state is passed with `_isNewUser` argument
    });

    // Test for Login Event (success scenario)
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when login is successful',
      build: () {
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => mockUserCredential);
        when(() => mockUserCredential.user).thenReturn(mockUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(LoginEvent(email: TestConstants.validEmail, password: TestConstants.validPassword)),
      expect: () => [AuthLoading(false), Authenticated(false, user: mockUser)], // Pass _isNewUser to AuthLoading and Authenticated
      verify: (_) {
        verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: TestConstants.validEmail,
              password: TestConstants.validPassword,
            )).called(1);
      },
    );

    // Test for Login Event (failure scenario)
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when login fails',
      build: () {
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(FirebaseAuthException(
          code: 'user-not-found',
          message: 'user-not-found',
        ));

        return authBloc;
      },
      act: (bloc) => bloc.add(
          LoginEvent(email: TestConstants.invalidEmail, password: TestConstants.invalidPassword)),
      expect: () => [
        AuthLoading(false), // Pass _isNewUser to AuthLoading
        AuthError(false, message: 'user-not-found'),
        AuthInitial(false)
      ], 
    );

    // Test for Signup Event (success scenario)
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when signup is successful',
      build: () {
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => mockUserCredential);
        when(() => mockUserCredential.user).thenReturn(mockUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(SignupEvent(email: TestConstants.validEmail, password: TestConstants.validPassword)),
      expect: () => [AuthLoading(false), Authenticated(false, user: mockUser)], // Pass _isNewUser to AuthLoading and Authenticated
    );

    // Test for Logout Event
    blocTest<AuthBloc, AuthState>(
      'emits [Unauthenticated] when logout is called',
      build: () {
        when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});
        return authBloc;
      },
      act: (bloc) => bloc.add(LogoutEvent()),
      expect: () => [Unauthenticated(false), AuthInitial(false)], // Pass _isNewUser to Unauthenticated
      verify: (_) {
        verify(() => mockFirebaseAuth.signOut()).called(1);
      },
    );

    // Test for Error Handling and Reset (if necessary)
    blocTest<AuthBloc, AuthState>(
      'emits [AuthError, AuthInitial] when error occurs',
      build: () {
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(FirebaseAuthException(
          code: 'user-not-found',
          message: 'user-not-found',
        ));
        return authBloc;
      },
      act: (bloc) => bloc.add(
          LoginEvent(email: TestConstants.invalidEmail, password: TestConstants.invalidPassword)),
      expect: () => [
        AuthLoading(false), // Pass _isNewUser to AuthLoading
        AuthError(false, message: 'user-not-found'),
        AuthInitial(false) // Ensure it resets to initial state
      ], 
    );
  });
}
