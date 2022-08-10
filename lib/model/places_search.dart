class PlaceSearchData {
  final String description;
  final String placeId;

  PlaceSearchData({required this.description, required this.placeId});

  Map toJson() {
    return {
      "description": description,
      "placeId": placeId
    };
  }

  factory PlaceSearchData.fromJson(Map<String, dynamic> json) {
    return PlaceSearchData(description: json["description"], placeId: json["place_id"]);
  }
}