import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unit2/model/profile/basic_info.dart';
import 'package:unit2/model/profile/basic_information/adress.dart';
import 'package:unit2/model/profile/basic_information/citizenship.dart';
import 'package:unit2/model/profile/basic_information/contact_information.dart';
import 'package:unit2/model/profile/basic_information/identification_information.dart';
import 'package:unit2/model/profile/profileInfomation.dart';
import 'package:unit2/utils/urls.dart';
import '../../model/profile/basic_information/primary-information.dart';
import '../../utils/request.dart';

class ProfileService {
  static final ProfileService _instance = ProfileService();
  static ProfileService get instance => _instance;

  Future<ProfileInformation?> getProfile(String token, int id) async {
    String url = Url.instance.profileInformation();
    String path = url + id.toString();
    ProfileInformation? profileInformation0;

    List<MainAdress> addresses = [];
    List<Identification> identificationInformation = [];
    List<ContactInfo> contactInformation = [];
    List<Citizenship> citizenships = [];
   int? profileId;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Token $token"
    };
    Map<String, String> param = {"basic": "true"};
    try {
      http.Response response = await Request.instance
          .getRequest(path: path, param: param, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
       profileId = data['data']['basic_information']['primary_information']['id'];
        // get all contacts
        if (data['data']['basic_information']['contact_information'] != null) {
          data['data']['basic_information']['contact_information']
              .forEach((var contact) {
            ContactInfo contactInfo =
                ContactInfo.fromJson(contact['contact_info']);
            contactInformation.add(contactInfo);
          });
        }

        // get all addresses
        if (data['data']['basic_information']['addresses'] != null) {
          data['data']['basic_information']['addresses'].forEach((var address) {
            MainAdress mainAdress = MainAdress.fromJson(address);
            addresses.add(mainAdress);
          });
        }

        // get all identifications
        if (data['data']['basic_information']['identification_records'] !=
            null) {
          data['data']['basic_information']['identification_records']!
              .forEach((var identity) {
            Identification identification = Identification.fromJson(identity);
            identificationInformation.add(identification);
          });
        }
        if(data['data']['basic_information']['citizenships'] != null){
            data['data']['basic_information']['citizenships']!
              .forEach((var citizenship) {
            Citizenship newCitizenShip = Citizenship.fromJson(citizenship);
            citizenships.add(newCitizenShip);
          });
        }

        BasicInfo basicInfo = BasicInfo(
            contactInformation: contactInformation,
            identifications: identificationInformation,
            citizenships: citizenships,
            addresses: addresses);

        ProfileInformation profileInformation = ProfileInformation(
          basicInfo: basicInfo,
          profileId: profileId!
        );
        profileInformation0 = profileInformation;
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw (e.toString());
    }
    return profileInformation0;
  }

  ////Update Profile info
  Future<Map<dynamic, dynamic>> updateBasicProfileInfo(
      {required String token,
      required int profileId,
      required Profile profileInfo,
      required int? genderId,
      required int? indigencyId,
      required int? disabilityId,
      required int? ethnicityId,
      required int? reqligionId}) async {
    String authtoken = "Token $token";
    String path = Url.instance.updatePersonalInfor();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authtoken
    };
    Map<dynamic, dynamic>? statusResponse = {};
    Map body = {
      "profile_id": profileId,
      "first_name": profileInfo.firstName,
      "middle_name": profileInfo.middleName!.isEmpty?null:profileInfo.middleName,
      "last_name": profileInfo.lastName,
      "name_extension": profileInfo.nameExtension,
      "birthdate": profileInfo.birthdate.toString(),
      "sex": profileInfo.sex,
      "blood_type": profileInfo.bloodType,
      "civil_status": profileInfo.civilStatus,
      "height": profileInfo.heightM,
      "weight": profileInfo.weightKg,
      "ethnicity_id": ethnicityId,
      "disability_id": disabilityId,
      "gender_id": genderId,
      "religion_id": reqligionId,
      "ip_id": indigencyId,
      "title_prefix": profileInfo.titlePrefix,
      "title_suffix": profileInfo.titleSuffix
    };
    try {
      http.Response response = await Request.instance
          .postRequest(path: path, headers: headers, body: body, param: {});
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        statusResponse = data;
      } else {
        statusResponse.addAll({'success': false});
      }
      return statusResponse;
    } catch (e) {
      throw e.toString();
    }
  }
}
