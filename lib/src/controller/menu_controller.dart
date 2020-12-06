import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuController extends GetxController{

  RxInt _index = 0.obs;
  RxList _selections = (List.generate(7, (_) => false)).obs;
  RxString _pagina = "Resumen".obs;
  final _pageController = PageController();
  
  set index(int index){
     this._index.value = index;
  _pageController.animateToPage(index, duration: Duration(milliseconds: 300), 
     curve: Curves.easeInCirc);
  }

 get pageController=> this._pageController;

 int get index => this._index.value;

 set pagina(String pagina){
   this._pagina.value = pagina;
 }

 String get pagina => this._pagina.value;

 List get selections => this._selections;

}




