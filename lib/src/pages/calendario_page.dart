import 'package:flutter/material.dart';
import 'package:student_calendar/src/pages/agregarAsignatura_page.dart';
import 'package:student_calendar/src/pages/agregarExamenes_page.dart';

class CalendarioPage extends StatelessWidget {
  const CalendarioPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
        child: Center(child: Text('Calendario'),),
      ),
       floatingActionButton: FloatingActionButton(onPressed: (){
         _mostrarAlerta(context);
       }, child: Icon(Icons.add)),
    );
  }

  void _mostrarAlerta(BuildContext context){
    showDialog(
      context: context, 
      builder: (context){
       return AlertDialog(
      title: Text("Agregar evento"),
       content: Column(
         mainAxisSize: MainAxisSize.min,
         mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            FlatButton(onPressed: (){
             MaterialPageRoute route =
                    MaterialPageRoute(builder: (context) => AgregarExamen());
                Navigator.pushReplacement(context, route);
          }, child: Text("Examen", style: TextStyle(color: Colors.blueGrey),)),
            SizedBox(height: 5,),
             FlatButton(onPressed: (){
             MaterialPageRoute route =
                    MaterialPageRoute(builder: (context) => AgregarAsignatura());
                Navigator.pushReplacement(context, route);
          }, child: Text("Asignatura", style: TextStyle(color: Colors.blueGrey),)),
          ],
        ),

        actions: [
          FlatButton(onPressed: (){
             Navigator.of(context).pop();
          }, child: Text("Cancelar", style: TextStyle(color: Colors.red),))
        ],
      );
    });

  }
}