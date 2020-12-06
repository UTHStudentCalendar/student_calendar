import 'package:flutter/material.dart';

class ResumenPage extends StatelessWidget {
  const ResumenPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 15.0),
                padding: EdgeInsets.all(8.0),
                height: 150,
                width: double.infinity,
                color: Colors.grey.withOpacity(0.1),
                child: Text("Reporte Semanal",
                    style: TextStyle(
                        color: Colors.blue[800], fontWeight: FontWeight.bold))),
            SizedBox(
              height: 10,
            ),
            Text("Hoy", style: Theme.of(context).textTheme.headline6),
            Container(
                margin: EdgeInsets.symmetric(vertical: 15.0),
                padding: EdgeInsets.all(5.0),
                width: double.infinity,
                color: Colors.grey.withOpacity(0.1),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Eventos",
                          style: TextStyle(
                              color: Colors.blue[800],
                              fontWeight: FontWeight.bold)),
                      Eventos(),
                       FlatButton(child: Row(children:[Icon(Icons.arrow_forward, color: Colors.black45,),SizedBox(width:10.0), Text("Mostrar más", style: TextStyle(color: Colors.black45),)]), onPressed: (){}, ),
                    ])),
            SizedBox(
              height: 10,
            ),
            Text("Mañana", style: Theme.of(context).textTheme.headline6),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15.0),
              width: double.infinity,
              padding: EdgeInsets.all(5.0),
              color: Colors.grey.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Eventos",
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold)),
                  Eventos(),
                  FlatButton(child: Row(children:[Icon(Icons.arrow_forward, color:Colors.black45,),SizedBox(width:10.0), Text("Mostrar más", style: TextStyle(color: Colors.black45))]), onPressed: (){}, ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class Eventos extends StatelessWidget {
  const Eventos({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      
      children: [
      ListTile(
        title: Text(
          "Categoría",
          style: Theme.of(context).textTheme.subtitle2,
        ),
        subtitle: Text("Título"),
      ),
      ListTile(
        title: Text(
          "Categoría",
          style: Theme.of(context).textTheme.subtitle2,
        ),
        subtitle: Text("Título"),
      ),
    ]);
  }
}
