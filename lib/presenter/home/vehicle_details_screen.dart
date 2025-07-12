import 'package:cos_challenge/data/models/vehicle_model.dart';
import 'package:flutter/material.dart';

class VehicleDetailsScreen extends StatelessWidget {
  const VehicleDetailsScreen({super.key, required this.vehicle});

  final VehicleModel vehicle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vehicle Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 6,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${vehicle.externalId}'),
            Text('Make: ${vehicle.make}'),
            Text('Model: ${vehicle.model}'),
            Text('Price: ${vehicle.price}'),
            Text('Feedback: ${vehicle.feedback}'),
            Text('Origin: ${vehicle.origin}'),
            const SizedBox(height: 8),
            Text('Valuated at: ${vehicle.valuatedAt}'),
            Text('Requested at: ${vehicle.requestedAt}'),
          ],
        ),
      ),
    );
  }
}
