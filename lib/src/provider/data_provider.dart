import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';

class SubscriberSeries {
  final String dia;
  final int total;
  final charts.Color barColor;

  SubscriberSeries(
      {@required this.dia,
      @required this.total,
      @required this.barColor});
}