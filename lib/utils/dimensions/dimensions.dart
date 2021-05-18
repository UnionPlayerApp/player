import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


// Размеры устройства в dp, выбранного в качестве образца для рассчета размеров виджетов и отступов
const double prototypeDeviceHeight = 780;
const double prototypeDeviceWidth = 390;

// Общие настройки
final EdgeInsets allSidesMargin = EdgeInsets.all(16.w);

//AppBar
final EdgeInsets appBarLeadingPadding = EdgeInsets.all(6.h) + EdgeInsets.only(left: 16.h);

// ScheduleScreen
// Разделитель
final double listViewDividerHeight = 2.h;
// Элемент списка
final double scheduleItemHeight = 105.h;
final double scheduleImageSide = 100.h;
final double titleFontSize = 16.0;
final double bodyFontSize = 13.0;
final EdgeInsets programTextLeftPadding = EdgeInsets.only(left: 10.w);
final EdgeInsets programBodyTopPadding = EdgeInsets.only(top: 10.h);

// FeedbackScreen
final EdgeInsets textFormFieldPadding = EdgeInsets.symmetric(horizontal: 10.w) + EdgeInsets.only(top: 15.h);


