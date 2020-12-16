import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_calendar/src/controller/chart_controller.dart';
import 'package:student_calendar/src/controller/menu_controller.dart';
import 'package:student_calendar/src/provider/data_provider.dart';
import 'package:student_calendar/src/provider/preferencias.dart';

class ResumenPage extends StatefulWidget {
  ResumenPage({Key key}) : super(key: key);

  @override
  _ResumenPageState createState() => _ResumenPageState();
}

final paginaController = Get.find<MenuController>();
final controller = Get.put<ChartController>(ChartController());

int date = DateTime.now().day;
Map<DateTime, int> listaTotal = {};
List<DateTime> fecha = List();
List<SubscriberSeries> data = [];
List<charts.Series<SubscriberSeries, String>> series = [];
int total = 0;
List dia = ["L", 'Ma', 'Mi', 'J', 'V', 'S', 'D'];
List<Color> colors = [Colors.blue, Colors.orange];


void _fecha(DateTime fecha){
      Stream<QuerySnapshot> listas = FirebaseFirestore.instance
          .collection('student_calendar')
          .where('fecha', isEqualTo: fecha)
          .where('id_usuario', isEqualTo: PreferenciasUsuario().usuario)
          .snapshots();
      listas.listen((data) {
        listaTotal[fecha] = data.docs.length;
      });
}

class _ResumenPageState extends State<ResumenPage> {
  @override
  void initState() {
    data.clear();
    series.clear();
    for (int i = 0; i < 7; i++) {
      fecha.add(DateTime(DateTime.now().year, DateTime.now().month, date + i));
      _fecha(fecha[i]);
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    for (int i = 0; i < 7; i++) {
      data.add(SubscriberSeries(
          dia: "${dia[i]}/${fecha[i].day}",
          total: listaTotal[fecha[i]],
          barColor: charts.ColorUtil.fromDartColor(colors[i % 2])));
    }

          series.add(charts.Series(
          id: "Subscribers",
          data: data,
          domainFn: (SubscriberSeries series, _) => series.dia,
          measureFn: (SubscriberSeries series, _) => series.total,
          colorFn: (SubscriberSeries series, _) => series.barColor));

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 15.0),
                padding: EdgeInsets.all(8.0),
                height: 300,
                width: double.infinity,
                color: Colors.grey.withOpacity(0.1),
                child: Column(
                  children: [
                    Text("Reporte Semanal",
                        style: TextStyle(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        height: 200,
                        alignment: Alignment.topLeft,
                        child: charts.BarChart(series,
                            animate: true,
                            animationDuration: Duration(seconds: 1),
                            behaviors: [
                              new charts.DatumLegend(
                                cellPadding: EdgeInsets.zero,
                                entryTextStyle: charts.TextStyleSpec(
                                    color: charts.MaterialPalette.black,
                                    fontSize: 10),
                              )
                            ])),
                  ],
                )),
            SizedBox(
              height: 10,
            ),
            Text("Hoy", style: Theme.of(context).textTheme.headline6),
            Container(
                margin: EdgeInsets.symmetric(vertical: 15.0),
                padding: EdgeInsets.all(5.0),
                height: 200,
                color: Colors.grey.withOpacity(0.1),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Eventos",
                          style: TextStyle(
                              color: Colors.blue[800],
                              fontWeight: FontWeight.bold)),
                      Expanded(
                          child: listas(DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day))),
                      FlatButton(
                        child: Row(children: [
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.black45,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            "Mostrar más",
                            style: TextStyle(color: Colors.black45),
                          )
                        ]),
                        onPressed: () {
                          _mostrar();
                        },
                      ),
                    ])),
            SizedBox(
              height: 10,
            ),
            Text("Mañana", style: Theme.of(context).textTheme.headline6),
            Container(
              width: double.infinity,
              height: 200,
              padding: EdgeInsets.all(5.0),
              color: Colors.grey.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Eventos",
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold)),
                  Expanded(
                      child: listas(DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day + 1))),
                  FlatButton(
                    child: Row(children: [
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.black45,
                      ),
                      SizedBox(width: 10.0),
                      Text("Mostrar más",
                          style: TextStyle(color: Colors.black45))
                    ]),
                    onPressed: () {
                      _mostrar();
                    },
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  void _mostrar() {
    paginaController.index = 2;
    paginaController.pagina = 'Agenda';
    for (int i = 0; i < 7; i++) {
      if (i == 2)
        paginaController.selections[i] = true;
      else
        paginaController.selections[i] = false;
    }
  }
}

Widget listas(fecha) {
  return Container(
    child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('student_calendar')
            .where('fecha', isEqualTo: fecha)
            .where('id_usuario', isEqualTo: PreferenciasUsuario().usuario)
            .limit(2)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child:  CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Algo salio mal'));
          }
          final data = snapshot.data.docs;

          if (data.isNotEmpty) {
            return ListView.builder(
                itemCount: snapshot.data.size,
                itemBuilder: (context, index) {
                  Map<String, dynamic> item = data[index].data();
                  return ListTile(
                    title: Text(
                        '${item['categoria'] == 'Horario' ? item['asignatura'] : item['nombre']}'),
                    subtitle: Text(
                        '${item['categoria'] == 'Horario' ? item['horai'] + " - " + item['horaf'] : item['descripcion'] ?? ''}'),
                    trailing: Text('${item['categoria'] ?? ''}',
                        style: TextStyle(color: Colors.blue)),
                  );
                });
          } else {
            return ListTile(title: Text("No hay eventos"));
          }
        }),
  );
}
