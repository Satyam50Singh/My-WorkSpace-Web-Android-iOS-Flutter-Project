import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../theme/app_colors.dart';
import '../utils/color_extension.dart';

class ExcelStyle {
  ExcelStyle._();

  static Style createHeaderStyle(Workbook workbook) {
    Style headerStyle = workbook.styles.add('headerStyle');
    headerStyle.bold = true;
    headerStyle.fontName = 'Times New Roman';
    headerStyle.fontSize = 12;
    headerStyle.hAlign = HAlignType.center;
    headerStyle.vAlign = VAlignType.center;
    headerStyle.borders.all.lineStyle = LineStyle.medium;
    headerStyle.fontColor = AppColors.white.toHex();
    headerStyle.backColor = AppColors.primaryDark.toHex();

    return headerStyle;
  }

  static Style createDataStyle(Workbook workbook) {
    Style dataStyle = workbook.styles.add('dataStyle');
    dataStyle.fontName = 'Sans Serif';
    dataStyle.fontSize = 11;
    dataStyle.hAlign = HAlignType.left;
    dataStyle.vAlign = VAlignType.center;
    dataStyle.borders.all.lineStyle = LineStyle.thin;
    return dataStyle;
  }
}
