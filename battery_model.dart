class Battery {
  final String documentId;
  final String image;
  final String model;
  final String name;
  final String quantity;

  Battery({
    required this.documentId,
    required this.image,
    required this.model,
    required this.name,
    required this.quantity,
  });

  factory Battery.fromJson(Map<String, dynamic> json, String documentId) {
    print("Battery fromJson documentId : $documentId");
    return Battery(
      documentId: documentId ?? "",
      image: json['image'] ?? "",
      model: json['model'] ?? "",
      name: json['name'] ?? "",
      quantity: json['quantity'] ?? "",
    );
  }
}
