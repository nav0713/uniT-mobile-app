part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetApkVersion extends UserEvent {
  final String? username;
  final String? password;
  GetApkVersion({required this.password, required this.username});
  @override
  List<Object> get props => [];
}

class UserLogin extends UserEvent {
  final String? username;
  final String? password;
  UserLogin({this.username, this.password});
  @override
  List<Object> get props => [username!, password!];
}

class LoadLoggedInUser extends UserEvent {
  LoadLoggedInUser();
}

class GetUuid extends UserEvent {
  GetUuid();
}

class LoadUuid extends UserEvent {
  LoadUuid();
}

class LoadVersion extends UserEvent {
  final String? username;
  final String? password;
  LoadVersion({this.password, this.username});
}

class UuidLogin extends UserEvent {
  final String? uuid;
  final String? password;
  UuidLogin({this.uuid, this.password});
  @override
  List<Object> get props => [uuid!, password!];
}
