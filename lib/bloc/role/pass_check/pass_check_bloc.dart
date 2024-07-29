import 'dart:io';

import 'package:barcode_scan2/model/scan_result.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unit2/model/roles/pass_check/pass_check_log.dart';
import 'package:unit2/model/roles/pass_check/passer_info.dart';
import 'package:unit2/screens/unit2/homepage.dart/components/dashboard/dashboard.dart';
import 'package:unit2/sevices/roles/pass_check_services.dart';
import 'package:unit2/utils/global.dart';
import 'package:unit2/utils/global_context.dart';
import '../../../utils/scanner.dart';
part 'pass_check_event.dart';
part 'pass_check_state.dart';

class PassCheckBloc extends Bloc<PassCheckEvent, PassCheckState> {
  PassCheckBloc() : super(PassCheckInitial()) {
    RoleIdRoleName? roleIdRoleName;
    String? uuid;
    bool? otherInputs;
    String? io;
    dynamic assignedArea;
    int? checkerId;
    String? token;
    int? stationId;
    String? cpId;
    List<PassCheckLog> globalLogs = [];
    DataTableSource? globalTableSource;
    ////filter logs
    String? passerFname;
    String? passerLname;
    String? startDate;
    String? endDate;
    on<GetPassCheckAreas>((event, emit) async {
      try {
        emit(PassCheckLoadingState());
        List<dynamic> response = await PassCheckServices.instance
            .getPassCheckArea(
                roleIdRoleName: RoleIdRoleName(
                    roleId: event.roleIdRoleName.roleId,
                    roleName: event.roleIdRoleName.roleName),
                userId: event.userId);
        emit(AssignAreaLoaded(
            assignedArea: response,
            roleIdRoleName: RoleIdRoleName(
                roleId: event.roleIdRoleName.roleId,
                roleName: event.roleIdRoleName.roleName)));
      } catch (e) {
        emit(PassCheckErrorState(message: e.toString()));
      }
    });
    on<SetScannerSettings>((event, emit) {
      otherInputs = event.includeOtherInputs;
      checkerId = event.checkerId;
      io = event.entranceExit;
      token = event.token;
      roleIdRoleName = event.roleIdRoleName;
      assignedArea = event.assignedArea;
      emit(SettingSaved(
          assignedArea: assignedArea,
          checker: checkerId!,
          io: io!,
          otherInputs: otherInputs!,
          roleIdRoleName: roleIdRoleName!,
          token: token!));
    });
    on<ScanError>((event, emit) {
      emit(SettingSaved(
          assignedArea: assignedArea,
          checker: checkerId!,
          io: io!,
          otherInputs: otherInputs!,
          roleIdRoleName: roleIdRoleName!,
          token: token!));
          
    });
    on<PerformIncomingPostLog>((event, emit) {
      add(PerformPostLogs(
          checkerId: checkerId!,
          cpId: cpId,
          destination: null,
          io: io!.toLowerCase() == "incoming" ? "i" : "o",
          otherInputs: otherInputs!,
          passerId: uuid!,
          roleId: roleIdRoleName!.roleId,
          roleName: roleIdRoleName!.roleName,
          stationId: stationId,
          temp: event.temp));
    });

    on<PerformOutgoingPostLog>((event, emit) {
      add(PerformPostLogs(
          checkerId: checkerId!,
          cpId: cpId,
          destination: event.destination,
          io: io!.toLowerCase() == "incoming" ? "i" : "o",
          otherInputs: otherInputs!,
          passerId: uuid!,
          roleId: roleIdRoleName!.roleId,
          roleName: roleIdRoleName!.roleName,
          stationId: stationId,
          temp: null));
    });
    on<ScanQr>((event, emit) async {
      ScanResult result = await QRCodeBarCodeScanner.instance.scanner();
      if (result.rawContent.toString().isNotEmpty) {
        uuid = result.rawContent.toString();
        emit(PassCheckLoadingState());
        try {
          PasserInfo? passerInfo = await PassCheckServices.instance
              .getPasserInfo(uuid: uuid!, token: event.token);
          if (roleIdRoleName!.roleName.toLowerCase() == "41" ||
              roleIdRoleName!.roleName.toLowerCase() == 'qr code scanner' ||
              roleIdRoleName!.roleName.toLowerCase() == 'office/branch chief' ||
              roleIdRoleName!.roleName.toLowerCase() ==
                  'registration in-charge') {
            stationId = assignedArea.id;
          } else if (roleIdRoleName!.roleName.toLowerCase() ==
              'barangay chairperson') {
            cpId = assignedArea.brgycode;
          } else if (roleIdRoleName!.roleName.toLowerCase() == 'purok pres') {
            cpId = assignedArea.purokdesc;
          } else if (roleIdRoleName!.roleName.toLowerCase() ==
              'establishment point-person') {
            cpId = assignedArea.id;
          }
          if (passerInfo == null) {
            Fluttertoast.showToast(
                msg: "QR CODE IS INVALID",
                fontSize: 24,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.black,
                textColor: Colors.white);
            emit(QRInvalid(token: token!));
          } else {
            if (otherInputs!) {
              if (io?.toLowerCase() == 'incoming') {
                emit(IncomingScanState());
              } else {
                emit(OutGoingScanState());
              }
            } else {
              add(PerformPostLogs(
                  checkerId: checkerId!,
                  cpId: cpId,
                  destination: null,
                  io: io!.toLowerCase() == "incoming" ? "i" : "o",
                  otherInputs: otherInputs!,
                  passerId: uuid!,
                  roleId: roleIdRoleName!.roleId,
                  roleName: roleIdRoleName!.roleName,
                  stationId: stationId,
                  temp: null));
            }
          }
        } catch (e) {
          emit(QRScanfailed(token: token!));
        }
      } else {
        emit(SettingSaved(
            assignedArea: assignedArea,
            checker: checkerId!,
            io: io!,
            otherInputs: otherInputs!,
            roleIdRoleName: roleIdRoleName!,
            token: token!));
      }
    });
    on<PerformPostLogs>((event, emit) async {
      emit(PassCheckLoadingState());
      try {
        final bool success = await PassCheckServices.instance.performPostLogs(
            passerId: event.passerId,
            chekerId: event.checkerId,
            temp: event.temp,
            destination: event.destination,
            io: event.io,
            stationId: event.stationId,
            cpId: event.cpId,
            otherInputs: event.otherInputs,
            roleIdRoleName: roleIdRoleName!);
        if (success) {
          Fluttertoast.showToast(
              msg: "SUCCESSFULLY SAVED",
              fontSize: 24,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.black,
              textColor: Colors.white);
          emit(ScanSuccess(token: token!));
        } else {
          Fluttertoast.showToast(
              msg: "SCAN FAILED",
              fontSize: 24,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.black,
              textColor: Colors.white);
          emit(ScanFailed(token: token!));
        }
      } catch (e) {
   emit(QRScanfailed(token: token!));
      }
    });
    on<ViewPassCheckLogs>((event, emit) async {
      emit(PassCheckLoadingState());
      try {
        List<PassCheckLog> logs = await PassCheckServices.instance
            .viewPassCheckLogs(webUserId: event.webUserId);
        final DataTableSource dataTableSource = MyData(logs: logs);
        if (logs.isNotEmpty) {
          globalLogs = logs;
          globalTableSource = dataTableSource;
          emit(PassCheckLogsLoaded(
              logs: logs, dataTableSource: dataTableSource));
        } else {
          emit(TodayEmptyPassCheckLogs());
        }
      } catch (e) {
        emit(PassCheckErrorState(message: e.toString()));
      }
    });
    on<FilterLogs>((event, emit) async {
      passerFname = event.passerName;
      passerLname = event.passerLastName;
      startDate = event.startDate;
      endDate = event.endDate;
      try {
        emit(PassCheckLoadingState());
        List<PassCheckLog> logs = await PassCheckServices.instance.filterLogs(
            webUserId: event.webUserId,
            passerName: passerFname,
            passerLname: passerLname,
            startDate: startDate,
            endDate: endDate);
        final DataTableSource dataTableSource = MyData(logs: logs);
        if (logs.isNotEmpty) {
          globalLogs = logs;
          globalTableSource = dataTableSource;
          emit(PassCheckLogsLoaded(
              logs: logs, dataTableSource: dataTableSource));
        } else {
          emit(FilterEmptyLogs(
              endDate: endDate,
              fname: passerFname,
              lname: passerLname,
              startDate: startDate));
        }
      } catch (e) {
        emit(ErrorFilterLogs(endDate: endDate,startDate: startDate,fname: passerFname,lname: passerLname,message: e.toString()));
      }
    });
    on<ShareLogs>((event, emit) async {
      emit(PassCheckLoadingState());
      try {
        final File? file = await PassCheckServices.instance.downloadPDFLogs(
            webUserId: event.webUserId,
            passerName: passerFname,
            passerLname: passerLname,
            startDate: startDate,
            endDate: endDate);
        if (file != null) {
          try {
            final result = await Share.shareXFiles([XFile(file.path)]);
            if (result.status == ShareResultStatus.success) {
              Fluttertoast.showToast(msg: "PDF logs shared successful");
              emit(PassCheckLogsLoaded(
                  logs: globalLogs, dataTableSource: globalTableSource!));
            } else {
              Fluttertoast.showToast(msg: "PDF logs share failed");
              emit(PassCheckLogsLoaded(
                  logs: globalLogs, dataTableSource: globalTableSource!));
            }
          } catch (e) {
   emit(ErrorFilterLogs(endDate: endDate,startDate: startDate,fname: passerFname,lname: passerLname,message: e.toString()));
          }
        } else {
          emit(PassCheckLogsLoaded(
              logs: globalLogs, dataTableSource: globalTableSource!));
        }
      } catch (e) {
    emit(ErrorFilterLogs(endDate: endDate,startDate: startDate,fname: passerFname,lname: passerLname,message: e.toString()));
      }
    });
  }
}

class MyData extends DataTableSource {
  final List<PassCheckLog> logs;
  MyData({required this.logs});
  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => logs.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    DateTime scanTime = logs[index].timeCheck!.add(const Duration(hours: 8));
    return DataRow(cells: [
      DataCell(Center(
          child: Text(
        ("${index + 1}."),
        style: Theme.of(NavigationService.navigatorKey.currentContext!)
            .textTheme
            .labelSmall!,
      ))),
      DataCell(Center(
        child: Text(
          "${logs[index].passerInfo!.givenname} ${logs[index].passerInfo!.familyname}",
          style: Theme.of(NavigationService.navigatorKey.currentContext!)
              .textTheme
              .labelSmall!,
        ),
      )),
      DataCell(Center(
        child: Text(
          logs[index].io == 'i' ? "In" : "Out",
          style: Theme.of(NavigationService.navigatorKey.currentContext!)
              .textTheme
              .labelSmall!,
        ),
      )),
      DataCell(Center(
        child: Text(
          dteTimeForm.format(scanTime),
          style: Theme.of(NavigationService.navigatorKey.currentContext!)
              .textTheme
              .labelSmall!,
        ),
      )),
      DataCell(Center(
        child: Text(
          logs[index].securityPointLocation!.station!.acronym!,
          style: Theme.of(NavigationService.navigatorKey.currentContext!)
              .textTheme
              .labelSmall!,
        ),
      )),
      DataCell(Center(
        child: Text(
          "${logs[index].checkerInfo!.firstName} ${logs[index].checkerInfo!.lastName}",
          style: Theme.of(NavigationService.navigatorKey.currentContext!)
              .textTheme
              .labelSmall!,
        ),
      )),
    ]);
  }
}
