class VehicleModel {
  const VehicleModel({
    required this.id,
    required this.feedback,
    required this.valuatedAt,
    required this.requestedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.make,
    required this.model,
    required this.externalId,
    required this.fkSellerUser,
    required this.price,
    required this.positiveCustomerFeedback,
    required this.fkAuction,
    required this.inspectorRequestedAt,
    required this.origin,
    required this.estimationRequestId,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
    id: json['id'] ?? 0,
    feedback: json['feedback'] ?? '',
    valuatedAt: DateTime.tryParse(json['valuatedAt'] ?? '') ?? DateTime(0),
    requestedAt: DateTime.tryParse(json['requestedAt'] ?? '') ?? DateTime(0),
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime(0),
    updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime(0),
    make: json['make'] ?? '',
    model: json['model'] ?? '',
    externalId: json['externalId'] ?? '',
    fkSellerUser: json['_fk_sellerUser'] ?? '',
    price: json['price'] ?? 0,
    positiveCustomerFeedback: json['positiveCustomerFeedback'] ?? false,
    fkAuction: json['_fk_uuid_auction'] ?? '',
    inspectorRequestedAt:
        DateTime.tryParse(json['inspectorRequestedAt'] ?? '') ?? DateTime(0),
    origin: json['origin'] ?? '',
    estimationRequestId: json['estimationRequestId'] ?? '',
  );

  final int id;
  final String feedback;
  final DateTime valuatedAt;
  final DateTime requestedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String make;
  final String model;
  final String externalId;
  final String fkSellerUser;
  final int price;
  final bool positiveCustomerFeedback;
  final String fkAuction;
  final DateTime inspectorRequestedAt;
  final String origin;
  final String estimationRequestId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VehicleModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          feedback == other.feedback &&
          valuatedAt == other.valuatedAt &&
          requestedAt == other.requestedAt &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          make == other.make &&
          model == other.model &&
          externalId == other.externalId &&
          fkSellerUser == other.fkSellerUser &&
          price == other.price &&
          positiveCustomerFeedback == other.positiveCustomerFeedback &&
          fkAuction == other.fkAuction &&
          inspectorRequestedAt == other.inspectorRequestedAt &&
          origin == other.origin &&
          estimationRequestId == other.estimationRequestId;

  @override
  int get hashCode =>
      id.hashCode ^
      feedback.hashCode ^
      valuatedAt.hashCode ^
      requestedAt.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      make.hashCode ^
      model.hashCode ^
      externalId.hashCode ^
      fkSellerUser.hashCode ^
      price.hashCode ^
      positiveCustomerFeedback.hashCode ^
      fkAuction.hashCode ^
      inspectorRequestedAt.hashCode ^
      origin.hashCode ^
      estimationRequestId.hashCode;
}
