import 'package:my_worksphere_web/core/export/excel_style.dart';
import 'package:my_worksphere_web/core/export/export_file_helper.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExcelExporter {
  Future<void> export({
    required String fileName,
    required String sheetName,
    required List<String> headers,
    required List<dynamic> dataList,
  }) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
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

      sheet.getRangeByIndex(row, 1).setText(ticket.ticketCode ?? '');
      sheet.getRangeByIndex(row, 2).setText(ticket.level ?? '');
      sheet.getRangeByIndex(row, 3).setText(ticket.ticketDate ?? '');
      sheet.getRangeByIndex(row, 4).setText(ticket.ticketStatus ?? '');
      sheet.getRangeByIndex(row, 5).setText(ticket.ticketActionStatus ?? '');
      sheet.getRangeByIndex(row, 6).setText(ticket.raisedByUser ?? '');
      sheet.getRangeByIndex(row, 7).setText(ticket.ticketType ?? '');
      sheet.getRangeByIndex(row, 8).setText(ticket.subCategory ?? '');
      sheet.getRangeByIndex(row, 9).setText(ticket.lastActionBy ?? '');
      sheet.getRangeByIndex(row, 10).setText(ticket.location ?? '');
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

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    await saveAndLaunchFile(bytes, fileName);
  }
}
