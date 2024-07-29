part of 'pass_check_bloc.dart';

abstract class PassCheckEvent extends Equatable {
  const PassCheckEvent();

  @override
  List<Object> get props => [];
}

class GetPassCheckAreas extends PassCheckEvent {
  final RoleIdRoleName roleIdRoleName;
  final int userId;
  const GetPassCheckAreas({required this.roleIdRoleName, required this.userId});
}

class SetScannerSettings extends PassCheckEvent {
  final RoleIdRoleName roleIdRoleName;
  final String token;
  final dynamic assignedArea;
  final bool includeOtherInputs;
  final String entranceExit;
  final int checkerId;
  const SetScannerSettings(
      {required this.assignedArea,
      required this.checkerId,
      required this.entranceExit,
      required this.includeOtherInputs,
      required this.roleIdRoleName,
      required this.token});
}

class ScanQr extends PassCheckEvent {
  final String token;

  const ScanQr({required this.token});
}

class PerformPostLogs extends PassCheckEvent {
  final String passerId;
  final int checkerId;
  final String io;
  final bool otherInputs;
  final String? cpId;
  final int? stationId;
  final String? destination;
  final double? temp;
  final String roleName;
  final int roleId;
  const PerformPostLogs(
      {required this.checkerId,
      required this.cpId,
      required this.destination,
      required this.io,
      required this.otherInputs,
      required this.passerId,
      required this.roleName,
      required this.roleId,
      required this.stationId,
      required this.temp});
}

class PerformIncomingPostLog extends PassCheckEvent {
  final double temp;
  const PerformIncomingPostLog({required this.temp});
}

class PerformOutgoingPostLog extends PassCheckEvent {
  final String destination;
  const PerformOutgoingPostLog({required this.destination});
}

class ScanError extends PassCheckEvent {}

class ViewPassCheckLogs extends PassCheckEvent {
  final int webUserId;
  const ViewPassCheckLogs({required this.webUserId});
}

class FilterLogs extends PassCheckEvent {
  final int webUserId;
  final String? startDate;
  final String? endDate;
  final String? passerName;
  final String? passerLastName;
  const FilterLogs(
      {required this.endDate,
      required this.startDate,
      required this.passerLastName,
      required this.passerName,
      required this.webUserId});
}

class ShareLogs extends PassCheckEvent {
  final int webUserId;
  const ShareLogs({required this.webUserId});
}
