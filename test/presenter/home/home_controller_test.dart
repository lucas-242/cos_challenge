import 'package:cos_challenge/data/models/api_error_model.dart';
import 'package:cos_challenge/data/models/suggestion_model.dart';
import 'package:cos_challenge/data/models/vehicle_model.dart';
import 'package:cos_challenge/data/repositories/auth/auth_repository.dart';
import 'package:cos_challenge/data/repositories/vehicle/vehicle_repository.dart';
import 'package:cos_challenge/data/repositories/vehicle/vehicle_response.dart';
import 'package:cos_challenge/presenter/home/home_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_controller_test.mocks.dart';

@GenerateMocks([AuthRepository, VehicleRepository])
void main() {
  late MockAuthRepository mockAuthRepository;
  late MockVehicleRepository mockVehicleRepository;
  late HomeController controller;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockVehicleRepository = MockVehicleRepository();
    controller = HomeController(mockVehicleRepository, mockAuthRepository, 17);

    provideDummy<VehicleResponse>(VehicleSuccess(_vehicleMock));
  });

  group('searchByVin', () {
    test('should set error if VIN is empty', () async {
      await controller.searchByVin('');
      expect(controller.error.value, 'VIN needs to have exactly 17 characters');
      expect(controller.isLoading.value, false);
    });

    test('should set error if VIN length is incorrect', () async {
      await controller.searchByVin('short');
      expect(controller.error.value, 'VIN needs to have exactly 17 characters');
      expect(controller.isLoading.value, false);
    });

    test(
      'should set vehicle and clear suggestions on VehicleSuccess',
      () async {
        when(
          mockVehicleRepository.fetchByVin(any),
        ).thenAnswer((_) async => VehicleSuccess(_vehicleMock));

        await controller.searchByVin('A' * 17);

        expect(controller.vehicle.value, _vehicleMock);
        expect(controller.suggestions.value, isEmpty);
        expect(controller.isLoading.value, false);
        expect(controller.error.value, isNull);
      },
    );

    test('should set sorted suggestions on VehicleSuggestions', () async {
      final suggestion1 = SuggestionModel(
        make: 'make1',
        model: 'model1',
        containerName: 'container1',
        similarity: 10,
        externalId: 'id1',
      );
      final suggestion2 = SuggestionModel(
        make: 'make2',
        model: 'model2',
        containerName: 'container2',
        similarity: 20,
        externalId: 'id2',
      );
      when(
        mockVehicleRepository.fetchByVin(any),
      ).thenAnswer((_) async => VehicleSuggestions([suggestion1, suggestion2]));

      await controller.searchByVin('A' * 17);

      expect(controller.suggestions.value, [suggestion2, suggestion1]);
      expect(controller.vehicle.value, isNull);
      expect(controller.isLoading.value, false);
      expect(controller.error.value, isNull);
    });

    test('should set error on VehicleFailure', () async {
      final apiError = ApiError(
        msgKey: 'key',
        message: 'error message',
        params: {},
      );
      when(
        mockVehicleRepository.fetchByVin(any),
      ).thenAnswer((_) async => VehicleFailure(apiError));

      await controller.searchByVin('A' * 17);

      expect(controller.error.value, 'error message');
      expect(controller.isLoading.value, false);
      expect(controller.vehicle.value, isNull);
      expect(controller.suggestions.value, isEmpty);
    });

    test('should set error on unexpected exception', () async {
      when(
        mockVehicleRepository.fetchByVin(any),
      ).thenThrow(Exception('Unexpected error'));

      await controller.searchByVin('A' * 17);

      expect(
        controller.error.value,
        'Unexpected error. Please try again later.',
      );
      expect(controller.isLoading.value, false);
      expect(controller.vehicle.value, isNull);
      expect(controller.suggestions.value, isEmpty);
    });
  });

  group('getVehicleFromSuggestion', () {
    test('should call _searchVehicle with default VIN', () async {
      when(
        mockVehicleRepository.fetchByVin(any),
      ).thenAnswer((_) async => VehicleSuccess(_vehicleMock));

      await controller.getVehicleFromSuggestion();

      verify(mockVehicleRepository.fetchByVin('A' * 17)).called(1);
      expect(controller.vehicle.value, _vehicleMock);
    });
  });

  group('signOut', () {
    test('should call authRepository.signOut', () async {
      when(
        mockAuthRepository.signOut(),
      ).thenAnswer((_) async => Future.value());

      controller.signOut();

      verify(mockAuthRepository.signOut()).called(1);
    });
  });

  group('dispose', () {
    test('should dispose all ValueNotifiers', () {
      final isLoadingNotifier = controller.isLoading;
      final errorNotifier = controller.error;
      final vehicleNotifier = controller.vehicle;
      final suggestionsNotifier = controller.suggestions;

      controller.dispose();

      expect(
        () => isLoadingNotifier.addListener(() {}),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => errorNotifier.addListener(() {}),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => vehicleNotifier.addListener(() {}),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => suggestionsNotifier.addListener(() {}),
        throwsA(isA<FlutterError>()),
      );
    });
  });
}

final _vehicleMock = VehicleModel(
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
