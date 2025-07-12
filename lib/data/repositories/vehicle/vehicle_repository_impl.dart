import 'dart:convert';

import 'package:cos_challenge/data/models/api_error_model.dart';
import 'package:cos_challenge/data/models/suggestion_model.dart';
import 'package:cos_challenge/data/models/vehicle_model.dart';
import 'package:cos_challenge/data/repositories/vehicle/vehicle_repository.dart';
import 'package:cos_challenge/data/repositories/vehicle/vehicle_response.dart';
import 'package:cos_challenge/shared/utils/cos_challenge.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  const VehicleRepositoryImpl();

  @override
  Future<VehicleResponse> fetchByVin(String vin) async {
    final response = await CosChallenge.httpClient.get(
      Uri.https('anyUrl'),
      headers: {CosChallenge.user: 'someUserId'},
    );

    switch (response.statusCode) {
      case 200:
        final data = json.decode(response.body) as Map<String, dynamic>;
        return VehicleSuccess(VehicleModel.fromJson(data));

      case 300:
        final list = json.decode(response.body) as List;
        return VehicleSuggestions(
          list.map((e) => SuggestionModel.fromJson(e)).toList(),
        );

      default:
        final error = json.decode(response.body);
        return VehicleFailure(ApiError.fromJson(error));
    }
  }
}
