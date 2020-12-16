
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_calendar/src/provider/preferencias.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarioPage extends StatefulWidget {
  CalendarioPage({Key key}) : super(key: key);

  @override
  _CalendarioPageState createState() => _CalendarioPageState();
}

CalendarController _calendarController;
AnimationController _animationController;

final Map<DateTime, List> _events = {};
List _selectedEvents = [];

class _CalendarioPageState extends State<CalendarioPage>
    with TickerProviderStateMixin {
  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.toString()),
                  onTap: () {},
                ),
              ))
          .toList(),
    );
  }


  @override
  void initState() {
    super.initState();
    lista();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _calendarController = CalendarController();
    _animationController.forward();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 5,),
            Center(child:Text("Toque el calendario para ver sus eventos")),
            TableCalendar(
              calendarStyle: CalendarStyle(
                selectedColor: Colors.blue[400],
                todayColor: Colors.blue[200],
                markersColor: Colors.blue[700],
                outsideDaysVisible: false,
              ),
              calendarController: _calendarController,
              locale: 'es_ES',
              events: _events,
              onDaySelected: _onDaySelected,
              builders:
                  CalendarBuilders(selectedDayBuilder: (context, date, _) {
                return FadeTransition(
                  opacity:
                      Tween(begin: 0.0, end: 1.0).animate(_animationController),
                  child: Container(
                    margin: const EdgeInsets.all(4.0),
                    padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                    color: Colors.blue[300],
                    width: 100,
                    height: 100,
                    child: Text(
                      '${date.day}',
                      style: TextStyle().copyWith(fontSize: 18.0),
                    ),
                  ),
                );
              }, markersBuilder: (context, date, events, holidays) {
                final children = <Widget>[];

                if (events.isNotEmpty) {
                  children.add(
                    Positioned(
                      bottom: 1,
                      child: Row(children: _buildEventsMarker(date, events)),
                    ),
                  );
                }
                return children;
              }),
            ),
            Expanded(child: _buildEventList()),
          ],
        ),
      ),
    );
  }
  void lista() {
    Stream<QuerySnapshot> listas = FirebaseFirestore.instance
        .collection('student_calendar')
        .where('id_usuario', isEqualTo: PreferenciasUsuario().usuario)
        .orderBy('fecha', descending: false)
        .snapshots();
    listas.listen((data) {
      _events.clear();

      int i=0;
        QueryDocumentSnapshot item = data.docs[i];
        DateTime fecha =  item['fecha'].toDate();
        DateTime fechaAnt = fecha;
        List<dynamic> eventos =  List();
        String evento;

     for (i = 0; i < data.docs.length; i++) {
          item = data.docs[i];
          fecha = item['fecha'].toDate();
          
            if(item['categoria']=='Horario'){
               evento = 'Asignatura:';
            }else
            if(item['categoria']=='Examen'){
               evento = 'Examen:';
            }else
            if(item['categoria']=='Tarea'){
               evento = 'Tarea:';
            }

          if(fecha == fechaAnt){
          eventos.add('$evento ${item['categoria']=='Horario'?item['asignatura']:item['nombre']}');
          }
          else
          {
          _events[fechaAnt] = eventos;
          
          eventos= new List();
          fechaAnt = fecha;
         eventos.add('$evento ${item['categoria']=='Horario'?item['asignatura']:item['nombre']}');
          }
      }
      _events[fechaAnt] = eventos;
    });
  
  }

  List<Widget> _buildEventsMarker(DateTime date, List events) {
    return events.map((e) {
      for (int i = 0; i < events.length; i++) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _calendarController.isSelected(date)
                ? Colors.blue[400]
                : _calendarController.isToday(date)
                    ? Colors.red
                    : Colors.blue[400],
          ),
          width: 8.0,
          height: 8.0,
          child: Center(),
        );
      }
    }).toList();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }
  
  
}
