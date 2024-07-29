import 'package:hive/hive.dart';

import '../login_data/user_info/module_object.dart';
part 'offlane_modules.g.dart';
@HiveType(typeId: 4)
class OfflineModules {
     @HiveField(0)
  final String roleName;
     @HiveField(1)
  final String moduleName;
     @HiveField(2)
  final ModuleObject object;
     @HiveField(3)
  final int roleId;
  const OfflineModules(
      {required this.moduleName, required this.object, required this.roleName,required this.roleId});
}