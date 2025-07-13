import 'package:cos_challenge/data/repositories/auth/auth_repository.dart';
import 'package:cos_challenge/data/repositories/vehicle/vehicle_repository.dart';
import 'package:cos_challenge/presenter/auth/auth_controller.dart';
import 'package:cos_challenge/presenter/auth/sign_in_screen.dart';
import 'package:cos_challenge/presenter/home/home_controller.dart';
import 'package:cos_challenge/presenter/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_in_screen_test.mocks.dart';

@GenerateMocks([
  AuthController,
  AuthRepository,
  HomeController,
  VehicleRepository,
])
void main() {
  late MockAuthController mockAuthController;
  late MockAuthRepository mockAuthRepository;
  late MockHomeController mockHomeController;
  late ValueNotifier<bool> isLoadingNotifier;
  late ValueNotifier<String?> errorNotifier;

  setUp(() {
    mockAuthController = MockAuthController();
    mockAuthRepository = MockAuthRepository();
    mockHomeController = MockHomeController();
    isLoadingNotifier = ValueNotifier(false);
    errorNotifier = ValueNotifier(null);

    when(mockAuthController.isLoading).thenReturn(isLoadingNotifier);
    when(mockAuthController.error).thenReturn(errorNotifier);
    when(mockAuthController.autoLogin()).thenAnswer((_) async => false);
    when(mockAuthController.signIn(any, any)).thenAnswer((_) async => true);
    when(mockAuthController.dispose()).thenAnswer((_) {});
    when(mockHomeController.dispose()).thenAnswer((_) {});
  });

  tearDown(() {
    isLoadingNotifier.dispose();
    errorNotifier.dispose();
  });

  Widget createSignInScreen() {
    return MaterialApp(
      home: SignInScreen(
        authRepository: mockAuthRepository,
        controller: mockAuthController,
      ),
    );
  }

  group('SignInScreen', () {
    testWidgets('should display Sign In title', (tester) async {
      await tester.pumpWidget(createSignInScreen());
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('should display Email and Password fields and Sign In button', (
      tester,
    ) async {
      await tester.pumpWidget(createSignInScreen());
      expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Sign in'), findsOneWidget);
    });

    testWidgets(
      'should call autoLogin on init and navigate to home if logged in',
      (tester) async {
        when(mockAuthController.autoLogin()).thenAnswer((_) async => true);
        await tester.pumpWidget(createSignInScreen());
        await tester.pumpAndSettle();

        verify(mockAuthController.autoLogin()).called(1);
        expect(find.byType(HomeScreen), findsOneWidget);
      },
    );

    testWidgets('should call signIn when Sign In button is pressed', (
      tester,
    ) async {
      await tester.pumpWidget(createSignInScreen());
      await tester.enterText(
        find.widgetWithText(TextField, 'Email'),
        'test@test.com',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Password'),
        'password',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));
      await tester.pumpAndSettle();

      verify(mockAuthController.signIn('test@test.com', 'password')).called(1);
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('should show CircularProgressIndicator when loading', (
      tester,
    ) async {
      isLoadingNotifier.value = true;
      await tester.pumpWidget(createSignInScreen());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Sign in'), findsNothing);
    });

    testWidgets('should display error message when error is not null', (
      tester,
    ) async {
      errorNotifier.value = 'Test Error Message';
      await tester.pumpWidget(createSignInScreen());
      await tester.pumpAndSettle();
    });
  });
}
