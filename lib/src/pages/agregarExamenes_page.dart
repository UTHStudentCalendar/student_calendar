import 'package:flutter/material.dart';

class AgregarExamen extends StatelessWidget {
  const AgregarExamen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Agregar Examen"),),
          body: Container(
        child: Center(child: Text("Agregar", ))
      ),
    );
  }
}