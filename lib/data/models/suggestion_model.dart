class SuggestionModel {
  const SuggestionModel({
    required this.make,
    required this.model,
    required this.containerName,
    required this.similarity,
    required this.externalId,
  });

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
      make: json['make'],
      model: json['model'],
      containerName: json['containerName'],
      similarity: json['similarity'],
      externalId: json['externalId'],
    );
  }

  final String make;
  final String model;
  final String containerName;
  final int similarity;
  final String externalId;
}
