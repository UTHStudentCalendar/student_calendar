import 'package:flutter/material.dart';

class HorarioPage extends StatelessWidget {
  const HorarioPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
        child: Center(child: Text('Horario', ),),
      ),
       floatingActionButton: FloatingActionButton(onPressed: (){}, child: Icon(Icons.add)),
    );
  }
}