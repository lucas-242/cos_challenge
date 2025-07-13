import 'package:cos_challenge/data/models/suggestion_model.dart';
import 'package:cos_challenge/data/models/vehicle_model.dart';
import 'package:cos_challenge/data/repositories/auth/auth_repository.dart';
import 'package:cos_challenge/data/repositories/vehicle/vehicle_repository.dart';
import 'package:cos_challenge/data/repositories/vehicle/vehicle_response.dart';
import 'package:flutter/material.dart';

class HomeController {
  HomeController(this._repository, this._authRepository, this._vinLength);

  final AuthRepository _authRepository;
  final VehicleRepository _repository;
  final int _vinLength;

  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<VehicleModel?> vehicle = ValueNotifier(null);
  final ValueNotifier<List<SuggestionModel>> suggestions = ValueNotifier([]);
  final ValueNotifier<String?> error = ValueNotifier(null);

  Future<void> searchByVin(String searchText) async {
    final vin = searchText.trim();
    if (vin.isEmpty || vin.length != _vinLength) {
      error.value = 'VIN needs to have exactly $_vinLength characters';
      return;
    }

    return _searchVehicle(vin);
  }

  Future<void> _searchVehicle(String vin) async {
    isLoading.value = true;
    error.value = null;

    try {
      final result = await _repository.fetchByVin(vin, 'someUserId');

      switch (result) {
        case VehicleSuccess():
          vehicle.value = result.vehicle;
          suggestions.value = [];
          break;
        case VehicleSuggestions():
          final sorted = List.of(result.suggestions)
            ..sort((a, b) => b.similarity.compareTo(a.similarity));
          suggestions.value = sorted;
          break;
        case VehicleFailure():
          error.value = result.error.message;
          break;
      }
    } catch (e) {
      error.value = 'Unexpected error. Please try again later.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getVehicleFromSuggestion() {
    final vin = List.filled(_vinLength, 'A').join();
    return _searchVehicle(vin);
  }

  void signOut() => _authRepository.signOut();

  void dispose() {
    isLoading.dispose();
    error.dispose();
    vehicle.dispose();
    suggestions.dispose();
  }
}
