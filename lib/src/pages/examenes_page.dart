import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:student_calendar/src/provider/preferencias.dart';
import 'package:toast/toast.dart';

class ExamenesPage extends StatelessWidget {
  const ExamenesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body:Column(children: [SizedBox(height:5),Expanded(child: listas())])  ,
       floatingActionButton: FloatingActionButton(onPressed: (){
       Navigator.pushNamed(context, 'agregar');
       }, child: Icon(Icons.add)),
    );
  }

   Widget listas() {
    return Container(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('student_calendar')
              .where('categoria', isEqualTo: "Examen")
              .where('id_usuario', isEqualTo: PreferenciasUsuario().usuario)
              .orderBy('fecha', descending: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
             return Center(child: CircularProgressIndicator());
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
                    Timestamp date = item['fecha'];
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      secondaryActions: [
                        IconSlideAction(
                          caption: 'Editar',
                          color: Colors.green,
                          onTap: () {
                            Navigator.of(context).pushNamed( 'agregar', arguments: data[index]);
                          },
                          icon: Icons.edit,
                        )
                      ],
                      actions: [
                        IconSlideAction(
                          caption: 'Eliminar',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () {
                            FirebaseFirestore.instance
                                .collection('student_calendar')
                                .doc(data[index].id)
                                .delete()
                                .then((value) {
                              Toast.show("Eliminado",context);
                            });
                          },
                        ),
                      ],
                      child: Card(
                        elevation: 3,
                        color: Colors.blue[20],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all( Radius.circular(5.0))),
                        child: ListTile(
                        onTap: (){
                        },
                        leading: Icon(
                          Icons.ballot,
                          color: Colors.blue,
                        ),
                        title: Text(
                          item['nombre'] ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${item['descripcion'] ?? ''}', style: TextStyle(fontSize: 15, color: Colors.blue),),
                            Text('${item['categoria'] ?? ''}'),
                          ],
                        ),
                        trailing: Text(
                          '${date.toDate().day}/${date.toDate().month}/${date.toDate().year}',
                          style: TextStyle(color: Colors.orange),
                        ),
                      )
                      ),
                    );
                  });
            } else {
              return Center(child: Text("Agregue nuevos exámenes"));
            }
          }),
    );
  }
}