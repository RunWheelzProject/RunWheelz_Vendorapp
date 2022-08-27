class PlaceSearchData {
  String? description;
  String? placeId;

  PlaceSearchData({this.description, this.placeId});

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