// ignore_for_file: public_member_api_docs, sort_constructors_first

class LikeModel {
  final int? id;
  final String? name;

  LikeModel({
    this.id,
    this.name,
  });

  factory LikeModel.fromJson(Map<String, dynamic> json) => LikeModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
