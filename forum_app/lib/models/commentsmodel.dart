import 'dart:convert';

CommentsModel weFromJson(String str) =>
    CommentsModel.fromJson(json.decode(str));

String weToJson(CommentsModel data) => json.encode(data.toJson());

class CommentsModel {
  int? id;
  int? userId;
  int? feedsId;
  String? comment;
  DateTime? createdAt;
  DateTime? updatedAt;
  Feeds? feeds;
  User? user;

  CommentsModel({
    required this.id,
    required this.userId,
    required this.feedsId,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.feeds,
    required this.user,
  });

  factory CommentsModel.fromJson(Map<String, dynamic> json) => CommentsModel(
        id: json["id"],
        userId: json["user_id"],
        feedsId: json["feeds_id"],
        comment: json["comment"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        feeds: Feeds.fromJson(json["feeds"]),
        user: User.fromJson(json["user"]),
      );

  set isExpanded(bool isExpanded) {}

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "feeds_id": feedsId,
        "comment": comment,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "feeds": feeds!.toJson(),
        "user": user!.toJson(),
      };
}

class Feeds {
  int? id;
  int? userId;
  String? content;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool liked;

  Feeds({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.liked,
  });

  factory Feeds.fromJson(Map<String, dynamic> json) => Feeds(
        id: json["id"],
        userId: json["user_id"],
        content: json["content"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        liked: json["liked"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "content": content,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "liked": liked,
      };
}

class User {
  int? id;
  String? username;
  String? name;
  String? email;
  dynamic? emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
