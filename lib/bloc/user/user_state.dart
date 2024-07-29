part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {
  UserInitial();
  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {
  final String? message;
  UserLoading({this.message});
  @override
  List<Object> get props => [message!];
}

class SplashScreen extends UserState {
  @override
  List<Object> get props => [];
}

class UserError extends UserState {
  final String? message;
  UserError({this.message});
  @override
  List<Object> get props => [];
}

class UserLoggedIn extends UserState {
  final List<AssignedArea>? estPersonAssignedArea;
  final UserData? userData;
  final String? message;
  final bool? success;
  final bool? savedCredentials;
  UserLoggedIn(
      {this.userData,
      this.message,
      this.success,
      this.savedCredentials,
      required this.estPersonAssignedArea});
}

class VersionLoaded extends UserState {
  final VersionInfo? versionInfo;
  final String? apkVersion;
  final String? username;
  final String? password;
  VersionLoaded(
      {this.versionInfo, this.apkVersion, this.password, this.username});
  @override
  List<Object> get props => [versionInfo!];
}

class UuidLoaded extends UserState {
  final String uuid;
  UuidLoaded({required this.uuid});
  @override
  List<Object> get props => [uuid];
}

class InternetTimeout extends UserState {
  final String message;
  InternetTimeout({required this.message});
  @override
  List<Object> get props => [message];
}

class InvalidCredentials extends UserState {
  final String message;
  InvalidCredentials({required this.message});
}

class LoginErrorState extends UserState {
  final String message;
  LoginErrorState({required this.message});
}

