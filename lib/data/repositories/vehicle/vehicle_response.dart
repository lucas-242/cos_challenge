import 'package:cos_challenge/data/models/api_error_model.dart';
import 'package:cos_challenge/data/models/suggestion_model.dart';
import 'package:cos_challenge/data/models/vehicle_model.dart';

sealed class VehicleResponse {}

class VehicleSuccess extends VehicleResponse {
  VehicleSuccess(this.vehicle);
  final VehicleModel vehicle;
}

class VehicleSuggestions extends VehicleResponse {
  VehicleSuggestions(this.suggestions);
  final List<SuggestionModel> suggestions;
}

class VehicleFailure extends VehicleResponse {
  VehicleFailure(this.error);
  final ApiError error;
}
