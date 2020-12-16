
import 'package:get/get.dart';
import 'package:student_calendar/src/provider/data_provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartController extends GetxController{


RxList<charts.Series<SubscriberSeries, String>> _series =  List<charts.Series<SubscriberSeries, String>>().obs;
      
 
 set series(List<charts.Series<SubscriberSeries, String>> valor)=> this._series.value = valor;
 
 List<charts.Series<dynamic, String>> get series => this._series;

 
}