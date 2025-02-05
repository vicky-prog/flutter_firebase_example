import 'package:flutter_firebase_example/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

// Step 1: Create Fake classes or Mocking FirebaseAuth and UserCredential
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

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
      expect(authBloc.state, equals(AuthInitial()));
    });

    // Test for Login Event
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when login is successful',
      build: () {
        // Simulating successful login
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => mockUserCredential);
        when(() => mockUserCredential.user).thenReturn(mockUser);
        return authBloc;
      },
      act: (bloc) => bloc
          .add(LoginEvent(email: 'test@example.com', password: 'password123')),
      expect: () => [AuthLoading(), Authenticated(user: mockUser)],
      verify: (_) {
        verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: 'test@example.com',
              password: 'password123',
            )).called(1);
      },
    );

    // Test for Login Event (failure scenario)
    // Test for failed Login (FirebaseAuthException)
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when login fails',
      build: () {
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(FirebaseAuthException(
          code: 'user-not-found',
          message: 'user-not-found', // Set the message explicitly
        ));

        return authBloc;
      },
      act: (bloc) => bloc.add(
          LoginEvent(email: 'wrong@example.com', password: 'wrongpassword')),
      expect: () => [
        AuthLoading(),
        AuthError(message: 'user-not-found')
      ], // Now match the actual message
    );

    // Test for Signup Event
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when signup is successful',
      build: () {
        // Simulating successful signup
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => mockUserCredential);
        when(() => mockUserCredential.user).thenReturn(mockUser);
        return authBloc;
      },
      act: (bloc) => bloc
          .add(SignupEvent(email: 'test@example.com', password: 'password123')),
      expect: () => [AuthLoading(), Authenticated(user: mockUser)],
    );

    // Test for Logout Event
    blocTest<AuthBloc, AuthState>(
      'emits [Unauthenticated] when logout is called',
      build: () {
        // Simulate logout action
        when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});
        return authBloc;
      },
      act: (bloc) => bloc.add(LogoutEvent()),
      expect: () => [Unauthenticated()],
      verify: (_) {
        verify(() => mockFirebaseAuth.signOut()).called(1);
      },
    );
  });
}
