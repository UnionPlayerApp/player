import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


// Размеры устройства в dp, выбранного в качестве образца для рассчета размеров виджетов и отступов
const double prototypeDeviceHeight = 780;
const double prototypeDeviceWidth = 390;

// Общие настройки
final EdgeInsets allSidesMargin = EdgeInsets.all(16.w);

//AppBar
final EdgeInsets appBarLeadingPadding = EdgeInsets.all(6.h) + EdgeInsets.only(left: 16.h);

// MainPage
final double mainImageSide = 200.w;
final double mainMarginBottom = 16.h;

// SchedulePage
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
final double bannerHeight = AppBar().preferredSize.height; // bannerHeight = app bar height
final Radius bannerBorderRadius = Radius.circular(10.0);


