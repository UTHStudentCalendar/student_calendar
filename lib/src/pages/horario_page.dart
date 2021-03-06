import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:student_calendar/src/provider/preferencias.dart';
import 'package:toast/toast.dart';

class HorarioPage extends StatelessWidget {
  const HorarioPage({Key key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body:  listas(),
       floatingActionButton: FloatingActionButton(onPressed: (){
       Navigator.pushNamed(context, 'agregarHorario');
       }, child: Icon(Icons.add)),
    );
  }

   Widget listas() {
    return Container(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('student_calendar')
              .where('categoria', isEqualTo: "Horario")
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
                            Navigator.of(context).pushNamed( 'agregarHorario', arguments: data[index]);
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
                          Icons.assignment,
                          color: Colors.blue,
                        ),
                        title: Text(
                          item['asignatura'] ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text('${item['horai']+' - '+ item['horaf'] ?? ''}', style: TextStyle(fontSize: 15, color: Colors.blue),),
                            
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
              return Center(child: Text("Agregue nuevos elementos al horario"));
            }
          }),
    );
  }
}