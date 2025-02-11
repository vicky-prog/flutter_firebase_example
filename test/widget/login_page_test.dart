import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_example/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_firebase_example/presentation/blocs/user/user_bloc.dart';
import 'package:flutter_firebase_example/presentation/pages/login_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock Classes
class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockUserBloc extends MockBloc<UserEvent, UserState> implements UserBloc {}

void main() {
  group('renders login page UI correctly', () {
    late MockAuthBloc mockAuthBloc;
    late MockUserBloc mockUserBloc;

    setUp(() {
      mockAuthBloc = MockAuthBloc();
      mockUserBloc = MockUserBloc();

      // Mock AuthBloc's `state` and `stream`
      when(() => mockAuthBloc.state).thenReturn(AuthInitial(false));
      when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(AuthInitial(false)));

      // Mock UserBloc's `state` and `stream`
      when(() => mockUserBloc.state).thenReturn(UserInitial());
      when(() => mockUserBloc.stream).thenAnswer((_) => Stream.value(UserInitial()));

      // Mock `close()` for both blocs
      when(() => mockAuthBloc.close()).thenAnswer((_) async {});
      when(() => mockUserBloc.close()).thenAnswer((_) async {});
    });

    tearDown(() {
      mockAuthBloc.close();
      mockUserBloc.close();
    });

    testWidgets('renders LoginPage correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: mockAuthBloc),
            BlocProvider<UserBloc>.value(value: mockUserBloc),
          ],
          child: MaterialApp(
            home: LoginPage(),
          ),
        ),
      );

      // Verify the logo is displayed
      expect(find.byType(Image), findsOneWidget);

      // Verify the title
      expect(find.text('SkillMentor Flutter Assistant'), findsOneWidget);

      // Verify the presence of input fields and button
      expect(find.text('Enter email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });


   testWidgets("triggers LoginEvent when SignIn button is pressed", (WidgetTester tester)async{
     await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: mockAuthBloc),
            BlocProvider<UserBloc>.value(value: mockUserBloc),
          ],
          child: MaterialApp(
            home: LoginPage(),
          ),
        ),
      );

         // Simulate user input
      await tester.enterText(
          find.widgetWithText(TextField, 'Enter email'), 'test@example.com');
      await tester.enterText(
          find.widgetWithText(TextField, 'Password'), 'password123');

      // Tap the SignIn button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Verify LoginEvent is added to AuthBloc
      verify(() => mockAuthBloc.add(LoginEvent(
            email: 'test@example.com',
            password: 'password123',
          ))).called(1);
   });

     testWidgets('shows CircularProgressIndicator when loading',
        (WidgetTester tester) async {
      // Mock loading state
      when(() => mockAuthBloc.state).thenReturn(AuthLoading(true));
     

      await tester.pumpWidget(
        BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: MaterialApp(home: LoginPage()),
        ),
      );

      // Verify CircularProgressIndicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

      testWidgets('shows SnackBar when AuthError state occurs',
        (WidgetTester tester) async {
      // Mock error state
      const errorMessage = 'Authentication failed';
      whenListen(
        mockAuthBloc,
        Stream<AuthState>.fromIterable([AuthError(false,message:errorMessage)]),
        initialState: AuthInitial(false),
      );

      await tester.pumpWidget(
        BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: MaterialApp(home: LoginPage()),
        ),
      );

      // Wait for the SnackBar to appear
      await tester.pump();

      // Verify the SnackBar shows the error message
      expect(find.text(errorMessage), findsOneWidget);
    });
  });
    
}


