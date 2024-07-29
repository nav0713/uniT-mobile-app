part of 'pass_check_bloc.dart';

abstract class PassCheckState extends Equatable {
  const PassCheckState();

  @override
  List<Object> get props => [];
}

class PassCheckInitial extends PassCheckState {}

class PassCheckErrorState extends PassCheckState {
  final String message;
  const PassCheckErrorState({required this.message});
}

class QRInvalid extends PassCheckState {
  final String token;
  const QRInvalid({required this.token});
}

class PassCheckLoadingState extends PassCheckState {}

class AssignAreaLoaded extends PassCheckState {
  final List<dynamic> assignedArea;
  final RoleIdRoleName roleIdRoleName;
  const AssignAreaLoaded(
      {required this.assignedArea, required this.roleIdRoleName});
}

class SettingSaved extends PassCheckState {
  final dynamic assignedArea;
  final String token;
  final String io;
  final int checker;
  final bool otherInputs;
  final RoleIdRoleName roleIdRoleName;
  const SettingSaved(
      {required this.assignedArea,
      required this.checker,
      required this.io,
      required this.otherInputs,
      required this.roleIdRoleName,
      required this.token});
}

class IncomingScanState extends PassCheckState {}

class OutGoingScanState extends PassCheckState {}

class ScanSuccess extends PassCheckState {
  final String token;
  const ScanSuccess({required this.token});
}

class ScanFailed extends PassCheckState {
  final String token;
  const ScanFailed({required this.token});
}

class QRCodeInvalid extends PassCheckState {
  final String token;
  const QRCodeInvalid({required this.token});
}

class PassCheckLogsLoaded extends PassCheckState {
  final List<PassCheckLog> logs;
  final DataTableSource dataTableSource;
  const PassCheckLogsLoaded({required this.logs, required this.dataTableSource});
  @override
  List<Object> get props => [logs,dataTableSource];
}

class TodayEmptyPassCheckLogs extends PassCheckState{
  
}

class FilterEmptyLogs extends PassCheckState{
  final String? fname;
  final String? lname;
 final String? startDate;
  final String? endDate;
  const FilterEmptyLogs({required this.endDate, required this.fname, required this.lname, required this.startDate});

}

class ErrorFilterLogs extends PassCheckState{
  final String message;
    final String? fname;
  final String? lname;
 final String? startDate;
  final String? endDate;
  const ErrorFilterLogs({required this.endDate, required this.fname, required this.lname, required this.startDate, required this.message});

}

class QRScanfailed extends PassCheckState{
  final String token;
  const QRScanfailed({required this.token});
}
