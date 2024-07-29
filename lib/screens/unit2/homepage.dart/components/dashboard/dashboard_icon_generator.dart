import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/maki_icons.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:fluttericon/web_symbols_icons.dart';

IconData? iconGenerator({required String name}) {
  if (name.toLowerCase() == 'agency') {
    return FontAwesome5.building;
  } else if (name.toLowerCase() == 'assignable role') {
    return FontAwesome5.user_plus;
  } else if (name.toLowerCase() == 'role') {
    return FontAwesome5.user;
  } else if (name.toLowerCase() == 'operation') {
    return FontAwesome.export_alt;
  } else if (name.toLowerCase() == 'module') {
    return Icons.view_module;
  } else if (name.toLowerCase() == 'area') {
    return FontAwesome5.map_marked;
  } else if (name.toLowerCase() == 'object') {
    return FontAwesome.box;
  } else if (name.toLowerCase() == 'permission') {
    return FontAwesome5.door_open;
  } else if (name.toLowerCase() == 'permission assignment') {
    return Icons.assignment_ind;
  } 
  else if (name.toLowerCase() == 'station') {
    return ModernPictograms.home;
  } else if (name.toLowerCase() == 'purok') {
    return WebSymbols.list_numbered;
  } else if (name.toLowerCase() == 'baranggay') {
    return Maki.industrial_building;
  } else if (name.toLowerCase() == 'role module') {
    return FontAwesome5.person_booth;
  } else if (name.toLowerCase() == 'module object') {
    return FontAwesome5.th_list;
  } else if (name.toLowerCase() == 'roles extend') {
    return FontAwesome5.external_link_square_alt;
  } else if (name.toLowerCase() == 'real property') {
    return FontAwesome5.eye;
  } else if (name.toLowerCase() == 'document') {
    return FontAwesome5.newspaper;
  } else if (name.toLowerCase() == 'role based access control') {
    return FontAwesome5.tasks;
  }  else if (name.toLowerCase() == 'pass check') {
    return FontAwesome5.qrcode;
  } else if (name.toLowerCase() == 'list of persons') {
    return FontAwesome5.users;
  } else if (name.toLowerCase() == 'person basic information') {
    return FontAwesome5.info_circle;
  }else if(name.toLowerCase() == "role member"){
    return FontAwesome5.users_cog;
  } 





   else if (name.toLowerCase() == 'security location') {
    return FontAwesome5.location_arrow;
  }
  
  else {
    return null;
  }
}
