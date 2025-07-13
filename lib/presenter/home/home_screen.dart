import 'package:cos_challenge/data/models/suggestion_model.dart';
import 'package:cos_challenge/data/repositories/auth/auth_repository.dart';
import 'package:cos_challenge/data/repositories/vehicle/vehicle_repository_impl.dart';
import 'package:cos_challenge/presenter/auth/sign_in_screen.dart';
import 'package:cos_challenge/presenter/home/components/suggestions_list.dart';
import 'package:cos_challenge/presenter/home/home_controller.dart';
import 'package:cos_challenge/presenter/home/vehicle_details_screen.dart';
import 'package:cos_challenge/shared/utils/cos_challenge.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.authRepository});
  final AuthRepository authRepository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeController _controller;
  late final _vinController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller = HomeController(
      VehicleRepositoryImpl(CosChallenge.httpClient),
      widget.authRepository,
      CosChallenge.vinLength,
    );

    _listenVehicle();
  }

  void _listenVehicle() {
    _controller.vehicle.addListener(() {
      final vehicle = _controller.vehicle.value;
      if (vehicle != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => VehicleDetailsScreen(vehicle: vehicle),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VIN Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _onSignOut,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder<bool>(
          valueListenable: _controller.isLoading,
          builder: (_, isLoading, __) {
            return Column(
              spacing: 16,
              children: [
                TextField(
                  controller: _vinController,
                  decoration: const InputDecoration(labelText: 'Type the VIN'),
                  maxLength: CosChallenge.vinLength,
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () => _controller.searchByVin(_vinController.text),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Search'),
                ),
                if (!isLoading)
                  ValueListenableBuilder<String?>(
                    valueListenable: _controller.error,
                    builder: (_, error, __) => error != null
                        ? Text(error, style: const TextStyle(color: Colors.red))
                        : const SizedBox.shrink(),
                  ),
                if (!isLoading)
                  ValueListenableBuilder<List<SuggestionModel>>(
                    valueListenable: _controller.suggestions,
                    builder: (_, suggestions, __) {
                      if (suggestions.isEmpty) return const SizedBox.shrink();
                      return SuggestionsList(
                        suggestions: suggestions,
                        onTap: (suggestion) =>
                            _controller.getVehicleFromSuggestion(),
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onSignOut() {
    _controller.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => SignInScreen(authRepository: widget.authRepository),
      ),
    );
  }
}
