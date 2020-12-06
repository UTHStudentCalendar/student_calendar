import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_calendar/src/controller/menu_controller.dart';

class AgendaPage extends StatelessWidget {
   AgendaPage({Key key}) : super(key: key);
final paginaController = Get.find<MenuController>();

 final List<String> opciones = [
  'Resumen',
  'Calendario',
  'Agenda',
  'Horario',
  'Examenes',
  'Asignatura',
  'Calificaciones',
  'Perfil'
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
        child: Center(child: Text("Agenda")
        // Obx(()=>ToggleButtons(
        //   children: [
        //    opcion(opciones[0],0),
        //    opcion(opciones[1],1),
        //    opcion(opciones[2],2),
        //    opcion(opciones[3],3),
        //    opcion(opciones[4],4),
        //    opcion(opciones[5],5),
        //    opcion(opciones[6],6),
        //    opcion(opciones[7],7),
        //    ],
        //    isSelected: paginaController.selections,
        //    onPressed: (int index){
        //      paginaController.selections[index] = !paginaController.selections[index];
        //    },
        //    color: Colors.blue,
        //    selectedColor: Colors.white,
        //    fillColor: Colors.blue,
        //    ))
           ),
      ),
       floatingActionButton: FloatingActionButton(onPressed: (){}, child: Icon(Icons.add)),
    );
  }


  Widget opcion(String opcion,int index){
    return 
     Icon(Icons.wallet_giftcard);
    // RaisedButton(
      
    //       // color: (Colors.blue),
    //       // textColor: (Colors.white),
    //           onPressed: (){
    //        // paginaController.index = index;
    //         //paginaController.pagina = opciones[index];
    //           },
    //         child: Center(child: Text("${opcion}"))
    //     );
  }
}