import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simpledebts/services/analytics_service.dart';

mixin AnalyticsUse {
  @protected
  final AnalyticsService analyticsService = GetIt.instance<AnalyticsService>();
}