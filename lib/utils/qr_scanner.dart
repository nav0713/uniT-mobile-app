import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:unit2/utils/scanner.dart';

Future<String?> qrScanner() async {
  String? result;
  try {
    ScanResult afterScan = await QRCodeBarCodeScanner.instance.scanner();
    if (afterScan.type == ResultType.Barcode) {
      result = afterScan.rawContent;
      return result;
    }
  } catch (e) {
    throw e.toString();
  }

  return null;
}
