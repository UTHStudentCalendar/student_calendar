import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:student_calendar/src/provider/preferencias.dart';
import 'package:toast/toast.dart';

class AgendaPage extends StatelessWidget {
  AgendaPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Center(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Expanded(child: listas()),
            ],
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _mostrarAlerta(context);
          },
          child: Icon(Icons.add)),
    );
  }

  void _mostrarAlerta(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Agregar Eventos"),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                title: Text("Agregar Examen"),
                leading: Icon(Icons.ballot, color: Colors.blue),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, 'agregar');
                },
              ),
              ListTile(
                title: Text("Agregar Horario"),
                leading: Icon(Icons.event, color: Colors.blue),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, 'agregarHorario');
                },
              ),
              ListTile(
                  title: Text("Agregar Tarea"),
                  leading: Icon(
                    Icons.assignment,
                    color: Colors.blue,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'agregarTarea');
                  })
            ]),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }

  Widget listas() {
    return Container(
      height: double.infinity,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('student_calendar')
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
                            if (item['categoria'] == 'Examen') {
                              Navigator.pushNamed(context, 'agregar',
                                  arguments: data[index]);
                            } else if (item['categoria'] == 'Tarea') {
                              Navigator.pushNamed(context, 'agregarTarea',
                                  arguments: data[index]);
                            }
                             else if (item['categoria'] == 'Horario') {
                              Navigator.pushNamed(context, 'agregarHorario',
                                  arguments: data[index]);
                            }
                            
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
                              Toast.show('Eliminado', context);
                            });
                          },
                        ),
                      ],
                      child: CardEventos(item: item, date: date),
                    );
                  });
            } else {
              return Center(child: Text("Agregue nuevos eventos"));
            }
          }),
    );
  }
}

class CardEventos extends StatelessWidget {
  const CardEventos({
    Key key,
    @required this.item,
    @required this.date,
  }) : super(key: key);

  final Map<String, dynamic> item;
  final Timestamp date;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: ListTile(
          onTap: () {},
          leading: Icon(
            Icons.event,
            color: Colors.blue,
          ),
          title: Text(item['categoria']=='Horario'? item['asignatura']:
            item['nombre'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${item['categoria']=='Horario'? item['horai']+' - '+ item['horaf']:item['descripcion'] ?? ''}'),
              Text('Asignatura: ${item['asignatura']}'),
              Text('Categoria: ${item['categoria']}'),
            ],
          ),
          trailing: Text(
            '${date.toDate().day}/${date.toDate().month}/${date.toDate().year}',
            style: TextStyle(color: Colors.orange),
          ),
        ));
  }
}
