import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  ///检查单个权限
  static Future<bool> checkPermission(Permission permission) async {
    final PermissionStatus status = await permission.status;
    return status.isGranted;
  }

  static void checkPermissions(List<Permission> perList) async {
    final Map<Permission, PermissionStatus> result = await perList.request();

    result.forEach((key, value) {});
  }
}
