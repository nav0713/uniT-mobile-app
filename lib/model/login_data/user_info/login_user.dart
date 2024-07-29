import 'role.dart';
class LoginUser {
  LoginUser({
    this.id,
    this.profileId,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.staff,
    this.roles,
  });

  int? id;
  int? profileId;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  bool? staff;
  List<Role?>? roles;

  factory LoginUser.fromJson(Map<String, dynamic> json) => LoginUser(
        id: json["id"],
        profileId: json["profile_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        username: json["username"],
        email: json["email"],
        staff: json["staff"],
        roles: json["roles"] == null
            ? []
            : List<Role?>.from(json["roles"]!.map((x) => Role.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile_id": profileId,
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "email": email,
        "staff": staff,
        "roles": roles == null
            ? []
            : List<dynamic>.from(roles!.map((x) => x!.toJson())),
      };
}