import 'package:unit2/model/profile/basic_information/adress.dart';
import 'package:unit2/model/profile/basic_information/citizenship.dart';
import 'package:unit2/model/profile/basic_information/contact_information.dart';
import 'package:unit2/model/profile/basic_information/identification_information.dart';

class BasicInfo{
  List<ContactInfo> contactInformation;
  List<Identification> identifications;
  List<Citizenship> citizenships;
  List<MainAdress> addresses;
    BasicInfo({required this.addresses, required this.contactInformation,required this.identifications,required this.citizenships});

}