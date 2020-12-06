import 'package:flutter/material.dart';

class ExamenesPage extends StatelessWidget {
  const ExamenesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
        child: Center(child: Text('Examenes', ),),
      ),
       floatingActionButton: FloatingActionButton(onPressed: (){}, child: Icon(Icons.add)),
    );
  }
}