import 'package:flutter/widgets.dart';
import 'package:union_player_app/utils/widgets/snapping_sheet_lib/sheet_size_behaviors.dart';
import 'package:union_player_app/utils/widgets/snapping_sheet_lib/snapping_sheet_content.dart';


abstract class SheetSizeCalculator {
  final SnappingSheetContent? sheetData;
  final double maxHeight;

  SheetSizeCalculator(
    this.sheetData,
    this.maxHeight,
  );

  double? getSheetStartPosition() {
    var sizeBehavior = sheetData!.sizeBehavior;
    if (sizeBehavior is SheetSizeFill) return 0;
    if (sizeBehavior is SheetSizeStatic) {
      if (!sizeBehavior.expandOnOverflow) return null;
      if (getVisibleHeight() > sizeBehavior.size) {
        return 0;
      }
    }
    return null;
  }

  double getVisibleHeight();
  double getSheetEndPosition();
  Positioned positionWidget({required Widget child});
}
