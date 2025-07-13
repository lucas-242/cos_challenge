class SuggestionModel {
  const SuggestionModel({
    required this.make,
    required this.model,
    required this.containerName,
    required this.similarity,
    required this.externalId,
  });

  factory SuggestionModel.fromJson(Map<String, dynamic> json) =>
      SuggestionModel(
        make: json['make'] ?? '',
        model: json['model'] ?? '',
        containerName: json['containerName'] ?? '',
        similarity: json['similarity'] ?? 0,
        externalId: json['externalId'] ?? '',
      );

  final String make;
  final String model;
  final String containerName;
  final int similarity;
  final String externalId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuggestionModel &&
          runtimeType == other.runtimeType &&
          make == other.make &&
          model == other.model &&
          containerName == other.containerName &&
          similarity == other.similarity &&
          externalId == other.externalId;

  @override
  int get hashCode =>
      make.hashCode ^
      model.hashCode ^
      containerName.hashCode ^
      similarity.hashCode ^
      externalId.hashCode;
}
