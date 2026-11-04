import 'package:flutter/cupertino.dart';
import 'package:my_worksphere_web/core/export/excel_style.dart';
import 'package:my_worksphere_web/core/export/export_file_helper.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExcelExporter {
  Future<void> export({
    required String fileName,
    required String sheetName,
    required List<String> headers,
    required List<dynamic> dataList,
    required Worksheet Function(Worksheet, int, dynamic) fillRowData,
  }) async {
    final Workbook workbook = Workbook();
    Worksheet sheet = workbook.worksheets[0];
    sheet.name = sheetName;
    sheet.showGridlines = true;

    Style headerStyle = ExcelStyle.createHeaderStyle(workbook);
    Style dataStyle = ExcelStyle.createDataStyle(workbook);

    for (int i = 0; i < headers.length; i++) {
      Range range = sheet.getRangeByIndex(1, i + 1);
      range.setText(headers[i]);
      range.cellStyle = headerStyle;
    }

    // 3. Add data
    for (int i = 0; i < dataList.length; i++) {
      final ticket = dataList[i];
      final int row = i + 2;
      sheet = fillRowData(sheet, row, ticket);
    }

    // 4. Apply data style to all rows at once and auto-fit
    if (dataList.isNotEmpty) {
      final Range dataRange = sheet.getRangeByIndex(
        2,
        1,
        dataList.length + 1,
        10,
      );
      dataRange.cellStyle = dataStyle;
      dataRange.autoFitColumns();
    }

    // Also auto-fit headers
    sheet.getRangeByIndex(1, 1, 1, 10).autoFitColumns();

    debugPrint('Exporting Excel file...');
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    await saveAndLaunchFile(bytes, fileName);
  }
}
