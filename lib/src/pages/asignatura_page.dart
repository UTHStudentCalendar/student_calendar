import 'package:flutter/material.dart';

class AsignaturaPage extends StatelessWidget {
  const AsignaturaPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ Text('Asignatura',),]
      ),
      ),
     floatingActionButton: FloatingActionButton(onPressed: (){}, child: Icon(Icons.add)),
    );
  }
}