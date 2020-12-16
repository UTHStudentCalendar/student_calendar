import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_calendar/src/controller/menu_controller.dart';

class PageViewMenu extends StatelessWidget {
  PageViewMenu({Key key}) : super(key: key);

  final paginaController = Get.find<MenuController>();

  final List<String> opciones = [
    'Calendario',
    'Resumen',
    'Agenda',
    'Horario',
    'Asignatura',
    'Examenes',
    'Calificaciones',
    'Tareas'
  ];

  @override
  Widget build(BuildContext context) {
  paginaController.selections[0] = true;
    paginaController.pagina = 'Calendario';
    for (int i = 1; i < opciones.length; i++) {
      paginaController.selections[i] = false;
    }

    return Container(
      height: 40,
      width: double.infinity,
      child: PageView.builder(
        controller: PageController(
          viewportFraction: 0.37,
          keepPage: true,
          initialPage: 0,
        ),
        itemCount: opciones.length,
        itemBuilder: (BuildContext context, int index) =>
            _opciones(opciones, index),
      ),
    );
  }

  Widget _opciones(List<String> opciones, int index) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.all(3),
        child: Obx(
          () => RaisedButton(
              onPressed: () {
                paginaController.index = index;
                paginaController.pagina = opciones[index];

                for (int i = 0; i < opciones.length; i++) {
                  if (i == index)
                    paginaController.selections[index] = true;
                  else
                    paginaController.selections[i] = false;
                }
              },
              color: (paginaController.selections[index]
                  ? Colors.white
                  : Colors.blue),
              textColor: (paginaController.selections[index]
                  ? Colors.blue
                  : Colors.white),
              child: Center(child: Text("${opciones[index]}"))),
        ));
  }
}
