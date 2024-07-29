 import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

BoxDecoration box1(){
  return const BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black12,spreadRadius: 5,blurRadius: 5)] ,
                      color: Colors.white,
                      borderRadius:  BorderRadius.all(Radius.circular(3)));
}
SuggestionDecoration searchFieldDecoration(){
    return  SuggestionDecoration(
                boxShadow:const [BoxShadow(color: Colors.black12,spreadRadius: 5,blurRadius: 5)] ,
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(3)));
}