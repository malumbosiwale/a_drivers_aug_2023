class Prediction {
  final description;
  final place_id;
  final reference;

  const Prediction({
    required this.description,
    required this.place_id,
    required this.reference,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      description: json['description'],
      place_id: json['place_id'],
      reference: json['reference'],
    );
  }
}


class PlaceIdR {
  final description;
  final place_id;
  final reference;

  const PlaceIdR({
    required this.description,
    required this.place_id,
    required this.reference,
  });

  factory PlaceIdR.fromJson(Map<String, dynamic> json) {
    return PlaceIdR(
      description: json['description'],
      place_id: json['place_id'],
      reference: json['reference'],
    );
  }
}
