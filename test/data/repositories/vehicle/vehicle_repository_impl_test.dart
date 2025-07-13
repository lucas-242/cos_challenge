import 'dart:convert';

import 'package:cos_challenge/data/models/api_error_model.dart';
import 'package:cos_challenge/data/models/suggestion_model.dart';
import 'package:cos_challenge/data/models/vehicle_model.dart';
import 'package:cos_challenge/data/repositories/vehicle/vehicle_repository_impl.dart';
import 'package:cos_challenge/data/repositories/vehicle/vehicle_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'vehicle_repository_impl_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late final VehicleRepositoryImpl repository;
  late final MockClient mockHttpClient;

  setUpAll(() {
    mockHttpClient = MockClient();
    repository = VehicleRepositoryImpl(mockHttpClient);
  });

  group('fetchByVin', () {
    const vin = 'vin';
    const userId = 'testUserId';

    test('should return VehicleSuccess on 200 status code', () async {
      final vehicleJson = {
        'vin': 'vin',
        'make': 'make',
        'model': 'model',
        'year': 2023,
      };
      when(
        mockHttpClient.get(any, headers: anyNamed('headers')),
      ).thenAnswer((_) async => http.Response(json.encode(vehicleJson), 200));

      final result = await repository.fetchByVin(vin, userId);

      expect(result, isA<VehicleSuccess>());
      expect(
        (result as VehicleSuccess).vehicle,
        VehicleModel.fromJson(vehicleJson),
      );
    });

    test('should return VehicleSuggestions on 300 status code', () async {
      final suggestionsJson = [
        {'code': 'code1', 'description': 'description1'},
        {'code': 'code2', 'description': 'description2'},
      ];
      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(json.encode(suggestionsJson), 300),
      );

      final result = await repository.fetchByVin(vin, userId);

      expect(result, isA<VehicleSuggestions>());
      expect((result as VehicleSuggestions).suggestions.length, 2);
      expect(
        result.suggestions[0],
        SuggestionModel.fromJson(suggestionsJson[0]),
      );
    });

    test('should return VehicleFailure on other status codes', () async {
      final errorJson = {'code': 'error', 'message': 'errorMessage'};
      when(
        mockHttpClient.get(any, headers: anyNamed('headers')),
      ).thenAnswer((_) async => http.Response(json.encode(errorJson), 400));

      final result = await repository.fetchByVin(vin, userId);

      expect(result, isA<VehicleFailure>());
      expect((result as VehicleFailure).error, ApiError.fromJson(errorJson));
    });

    test('should throw an exception if http client throws an error', () async {
      when(
        mockHttpClient.get(any, headers: anyNamed('headers')),
      ).thenThrow(Exception('Network error'));

      final call = repository.fetchByVin;

      expect(() => call(vin, userId), throwsA(isA<Exception>()));
    });
  });
}
