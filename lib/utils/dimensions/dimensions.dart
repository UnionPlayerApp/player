import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


// Размеры устройства в dp, выбранного в качестве образца для расчета размеров виджетов и отступов
const double prototypeDeviceHeight = 780;
const double prototypeDeviceWidth = 390;

// Общие настройки
final EdgeInsets allSidesMargin = EdgeInsets.all(16.w);

// AppBar
final EdgeInsets appBarLeadingPadding = EdgeInsets.all(3.h);

// Audio Quality Selector
final EdgeInsets appAudioQualitySelectorPadding = EdgeInsets.all(3.h);

// MainPage
const mainImageSize = 210.0;
final double mainItemExtent = 335.w;
final double mainMarginBottom = 16.h;

// SchedulePage
// Разделитель
final double listViewDividerHeight = 2.h;
// Элемент списка
final scheduleItemPadding = 12.h;
final scheduleItemHeight = 105.h;
final scheduleImageSide = 100.h;
const titleFontSize = 16.0;
const artistFontSize = 13.0;
final programTextLeftPadding = EdgeInsets.only(left: 10.w);
final programBodyTopPadding = EdgeInsets.only(top: 10.h);

// FeedbackScreen
final double bannerHeight = AppBar().preferredSize.height; // bannerHeight = app bar height
const Radius bannerBorderRadius = Radius.circular(10.0);


