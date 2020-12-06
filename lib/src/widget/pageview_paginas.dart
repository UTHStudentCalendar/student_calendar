import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_calendar/src/controller/menu_controller.dart';
import 'package:student_calendar/src/pages/agenda_page.dart';
import 'package:student_calendar/src/pages/asignatura_page.dart';
import 'package:student_calendar/src/pages/calendario_page.dart';
import 'package:student_calendar/src/pages/calificaciones_page.dart';
import 'package:student_calendar/src/pages/examenes_page.dart';
import 'package:student_calendar/src/pages/horario_page.dart';
import 'package:student_calendar/src/pages/resumen_page.dart';

class PageViewPagina extends StatelessWidget {
   PageViewPagina({Key key}) : super(key: key);
   
   final paginaController = Get.put<MenuController>(MenuController());

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: MediaQuery.of(context).size.height * 0.85,
      width: double.infinity,
      child: PageView(
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        controller: paginaController.pageController,
        children: [ResumenPage(), CalendarioPage(), AgendaPage(),HorarioPage(), ExamenesPage(), AsignaturaPage(),CalificacionesPage()],
      ),
        
    );
  }
}
