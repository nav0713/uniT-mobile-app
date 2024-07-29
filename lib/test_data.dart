import 'package:azlistview/azlistview.dart';

List<String> levels = ['Establishments', 'Office'];
List<String> establishments = ['Provincial Government of Agusan del Norte'];
List<String> checkPointAreas = [
  'Agusan Up',
  'Bids and Awards Committee',
  'Cabadbaran District Hospital',
  'Commision on Audit'
];

final List<String> genders = ["MALE", "FEMALE"];
final List<String> regions = [
  "Region I",
  "Region II",
  "Region III",
  "Region IV",
  "Region V"
];
final List<String> barangays = [
  "Ambago",
  "Lingayao",
  "Obrero",
  "Bading",
  "Limaha",
  "Peqeno"
];
final List<String> puroks = [
  "Ambago",
  "Lingayao",
  "Obrero",
  "Bading",
  "Limaha",
  "Peqeno"
];

final List<String> municipalities = [
  "Buenavista",
  "Butuan City",
  "Carmen",
  "Cabadbaran",
  "Jabonga"
];
final List<String> provinces = [
  "Agusan del Norte",
  "Agusan del Sur",
  "Surigao del Norte",
  "Surigao del Sur"
];

List<Person> addedPersons = [
  Person(name: "Nav", lastname: "Acuin"),
  Person(name: "Jhonny", lastname: "Agoy"),
  Person(name: "Philip", lastname: "Amaw"),
  Person(name: "Jojo", lastname: "Asus"),
  Person(name: "Naruto", lastname: "Acer"),
  Person(name: "Agata", lastname: "Azarcon"),
  Person(name: "Nav", lastname: "Amen"),
  Person(name: "Cristine", lastname: "Albarina"),
  Person(name: "Nav", lastname: "Zcuin"),
  Person(name: "Jhonny", lastname: "Zgoy"),
  Person(name: "Philip", lastname: "Zmaw"),
  Person(name: "Jojo", lastname: "Zsus"),
  Person(name: "Naruto", lastname: "Zcer"),
  Person(name: "Agata", lastname: "Zzarcon"),
  Person(name: "Nav", lastname: "Zmen"),
  Person(name: "Cristine", lastname: "Zlbarina"),
  Person(name: "Nav", lastname: "Bcuin"),
  Person(name: "Jhonny", lastname: "Tgoy"),
  Person(name: "Philip", lastname: "Smaw"),
  Person(name: "Jojo", lastname: "Dsus"),
  Person(name: "Naruto", lastname: "Fcer"),
  Person(name: "Agata", lastname: "Ezarcon"),
  Person(name: "Nav", lastname: "Cmen"),
  Person(name: "Cristine", lastname: "Blbarina"),
];

class Person extends ISuspensionBean {
  final String name;
  final String lastname;
  Person({required this.name, required this.lastname});

  @override
  String getSuspensionTag() {
    return lastname[0];
  }
}

// List<Roles> roles = [
//   Roles(name: 'QR scanner', icon: FontAwesome.qrcode),
//   Roles(name: "Security", icon: FontAwesome5.user_shield),
//   Roles(name: "Establishment point person", icon: FontAwesome.building_filled),
//   Roles(name: "Registration in charge", icon: FontAwesome.user_plus),
//   Roles(name: 'Super admin', icon: FontAwesome5.user_lock),
//   Roles(name: "Purok president", icon: FontAwesome5.user_tie),
//   Roles(name: "Check point inchage", icon: FontAwesome5.hand_paper),
//   Roles(name: "Health officer", icon: RpgAwesome.health_decrease),

// ];


