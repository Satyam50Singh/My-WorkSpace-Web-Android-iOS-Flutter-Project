import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  final String path = (await getApplicationDocumentsDirectory()).path;
  final String fileLocation = '$path/$fileName';
  final File file = File(fileLocation);
  await file.writeAsBytes(bytes, flush: true);
  await OpenFile.open(fileLocation);
}
