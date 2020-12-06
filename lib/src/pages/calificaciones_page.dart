import 'package:flutter/material.dart';

class CalificacionesPage extends StatelessWidget {
  const CalificacionesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ Text('Calificaciones',),]
      ),
      ),
     floatingActionButton: FloatingActionButton(onPressed: (){}, child: Icon(Icons.add)),
    );
  }
}