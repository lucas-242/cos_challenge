import 'package:cos_challenge/data/repositories/vehicle/vehicle_response.dart';

abstract interface class VehicleRepository {
  Future<VehicleResponse> fetchByVin(String vin);
}
