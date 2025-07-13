import 'package:cos_challenge/data/models/suggestion_model.dart';
import 'package:cos_challenge/data/models/vehicle_model.dart';
import 'package:cos_challenge/data/repositories/auth/auth_repository.dart';
import 'package:cos_challenge/presenter/auth/sign_in_screen.dart';
import 'package:cos_challenge/presenter/home/components/suggestions_list.dart';
import 'package:cos_challenge/presenter/home/home_controller.dart';
import 'package:cos_challenge/presenter/home/home_screen.dart';
import 'package:cos_challenge/presenter/home/vehicle_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_screen_test.mocks.dart';

@GenerateMocks([HomeController, AuthRepository])
void main() {
  late MockHomeController mockHomeController;
  late MockAuthRepository mockAuthRepository;
  late ValueNotifier<bool> isLoadingNotifier;
  late ValueNotifier<VehicleModel?> vehicleNotifier;
  late ValueNotifier<List<SuggestionModel>> suggestionsNotifier;
  late ValueNotifier<String?> errorNotifier;

  setUp(() {
    mockHomeController = MockHomeController();
    mockAuthRepository = MockAuthRepository();
    isLoadingNotifier = ValueNotifier(false);
    vehicleNotifier = ValueNotifier(null);
    suggestionsNotifier = ValueNotifier([]);
    errorNotifier = ValueNotifier(null);

    when(mockHomeController.isLoading).thenReturn(isLoadingNotifier);
    when(mockHomeController.vehicle).thenReturn(vehicleNotifier);
    when(mockHomeController.suggestions).thenReturn(suggestionsNotifier);
    when(mockHomeController.error).thenReturn(errorNotifier);
    when(mockHomeController.searchByVin(any)).thenAnswer((_) async {});
    when(
      mockHomeController.getVehicleFromSuggestion(),
    ).thenAnswer((_) async {});
    when(mockHomeController.signOut()).thenAnswer((_) {});
    when(mockHomeController.dispose()).thenAnswer((_) {});
  });

  tearDown(() {
    isLoadingNotifier.dispose();
    vehicleNotifier.dispose();
    suggestionsNotifier.dispose();
    errorNotifier.dispose();
  });

  Widget createHomeScreen() {
    return MaterialApp(
      home: HomeScreen(
        authRepository: mockAuthRepository,
        controller: mockHomeController,
      ),
    );
  }

  group('HomeScreen', () {
    testWidgets('should display VIN Search title', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      expect(find.text('VIN Search'), findsOneWidget);
    });

    testWidgets('should display TextField and Search button', (tester) async {
      await tester.pumpWidget(createHomeScreen());

      expect(find.widgetWithText(TextField, 'Type the VIN'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Search'), findsOneWidget);
    });

    testWidgets('should call searchByVin when Search button is pressed', (
      tester,
    ) async {
      await tester.pumpWidget(createHomeScreen());
      await tester.enterText(find.byType(TextField), 'TESTVIN123456789');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Search'));
      await tester.pumpAndSettle();

      verify(mockHomeController.searchByVin('TESTVIN123456789')).called(1);
    });

    testWidgets('should show CircularProgressIndicator when loading', (
      tester,
    ) async {
      isLoadingNotifier.value = true;

      await tester.pumpWidget(createHomeScreen());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Search'), findsNothing);
    });

    testWidgets('should display error message when error is not null', (
      tester,
    ) async {
      errorNotifier.value = 'Test Error Message';

      await tester.pumpWidget(createHomeScreen());
      await tester.pump();

      expect(find.text('Test Error Message'), findsOneWidget);
    });

    testWidgets('should display suggestions when suggestions are available', (
      tester,
    ) async {
      suggestionsNotifier.value = [
        const SuggestionModel(
          make: 'make',
          model: 'model',
          containerName: 'container',
          similarity: 10,
          externalId: 'id',
        ),
      ];

      await tester.pumpWidget(createHomeScreen());
      await tester.pump();

      expect(find.byType(SuggestionsList), findsOneWidget);
      expect(find.text('make model'), findsOneWidget);
    });

    testWidgets(
      'should navigate to VehicleDetailsScreen when vehicle is available',
      (tester) async {
        final vehicle = VehicleModel(
          id: 1,
          feedback: 'feedback',
          valuatedAt: DateTime.now(),
          requestedAt: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          make: 'make',
          model: 'model',
          externalId: 'externalId',
          fkSellerUser: 'fkSellerUser',
          price: 100,
          positiveCustomerFeedback: true,
          fkAuction: 'fkAuction',
          inspectorRequestedAt: DateTime.now(),
          origin: 'origin',
          estimationRequestId: 'estimationRequestId',
        );

        await tester.pumpWidget(createHomeScreen());
        vehicleNotifier.value = vehicle;
        await tester.pumpAndSettle();

        expect(find.byType(VehicleDetailsScreen), findsOneWidget);
      },
    );

    testWidgets('should navigate to SignInScreen on logout', (tester) async {
      when(mockAuthRepository.autoLogin()).thenAnswer((_) async => null);

      await tester.pumpWidget(createHomeScreen());
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      verify(mockHomeController.signOut()).called(1);
      expect(find.byType(SignInScreen), findsOneWidget);
    });
  });
}
