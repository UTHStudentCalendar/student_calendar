import 'package:flutter/material.dart';

class AgregarAsignatura extends StatelessWidget {
  const AgregarAsignatura({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Agregar Asignatura"),),
          body: Container(
        child: Center(child: Text("Agregar", ))
      ),
    );
  }
}