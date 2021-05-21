import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:union_player_app/utils/dimensions/dimensions.dart';
import 'package:union_player_app/utils/widgets/snapping_sheet_lib/snapping_position.dart';
import 'package:union_player_app/utils/widgets/snapping_sheet_lib/snapping_sheet_content.dart';
import 'package:union_player_app/utils/widgets/snapping_sheet_lib/snapping_sheet_widget.dart';

import 'default_grabbing.dart';

class FeedbackSnappingSheet extends StatelessWidget {
  final Widget sheetContent;
  final ScrollController _scrollController = ScrollController();

  FeedbackSnappingSheet(this.sheetContent);

  @override
  Widget build(BuildContext context) {
    return
      SnappingSheet(
        initialSnappingPosition:
          SnappingPosition.pixels(
            snappingCurve: Curves.linear,
            snappingDuration: Duration(milliseconds: 200),
            positionPixels: MediaQuery.of(context).size.height - bannerHeight - appBarHeight,
            grabbingContentOffset: GrabbingContentOffset.top,
            ),
        snappingPositions: [
          SnappingPosition.pixels(
            snappingCurve: Curves.linear,
            snappingDuration: Duration(milliseconds: 200),
            positionPixels: MediaQuery.of(context).size.height - bannerHeight - appBarHeight,
            grabbingContentOffset: GrabbingContentOffset.top,
          ),
          SnappingPosition.factor(
            grabbingContentOffset: GrabbingContentOffset.bottom,
            positionFactor: 1.0,
          ),
        ],
        child: null,
        grabbingHeight: grabbingHeight,
        grabbing: DefaultGrabbing(),
        sheetAbove: SnappingSheetContent(
          childScrollController: _scrollController,
          draggable: true,
          child: SingleChildScrollView(
            reverse: true,
            controller: _scrollController,
            child: sheetContent,
          ),
        ),
        sheetSize: MediaQuery.of(context).size.height,
      );
  }
}
