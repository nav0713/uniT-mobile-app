import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:unit2/model/location/address_category.dart';
import 'package:unit2/model/location/barangay.dart';
import 'package:unit2/model/location/city.dart';
import 'package:unit2/model/location/country.dart';
import 'package:http/http.dart' as http;
import 'package:unit2/model/location/provinces.dart';
import 'package:unit2/model/location/purok.dart';
import 'package:unit2/utils/request.dart';
import 'package:unit2/utils/urls.dart';

import '../model/location/region.dart';

class LocationUtils {
  static final LocationUtils _instance = LocationUtils();
  static LocationUtils get instance => _instance;

  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  Future<List<Country>> getCountries() async {
    List<Country> countries = [];
    String path = Url.instance.getCounties();

    try {
      http.Response response = await Request.instance
          .getRequest(path: path, param: {}, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          data['data'].forEach((var country) {
            Country newCOuntry = Country.fromJson(country);
            countries.add(newCOuntry);
          });
        }
      }
    } catch (e) {
      throw (e.toString());
    }
    return countries;
  }

  Future<List<Region>> getRegions() async {
    List<Region> regions = [];
 
    try {
               final String regionString = await rootBundle.loadString('assets/address/region.json');
               var map =jsonDecode(regionString);
      map['loc_region'].forEach((var region){
       regions.add(Region(code: region['regcode'], description: region['regdesc'], psgcCode: region['psgccode']));
      });
    } catch (e) {
      throw (e.toString());
    }
    return regions;
  }

  Future<List<Province>> getProvinces({required  Region selectedRegion}) async {
    List<Province> provinces = [];

    try {
           final String provinceString = await rootBundle.loadString('assets/address/province.json');
            var map = jsonDecode(provinceString);
      map['loc_province'].forEach((var province){
      if(province['regcode'] == selectedRegion.code){
         provinces.add(Province(code: province['provcode'], description: province['provdesc'], region: selectedRegion, psgcCode: province['psgccode'], shortname: province['shortname']));
      }
      });
    } catch (e) {
      throw (e.toString());
    }
    return provinces;
  }

  Future<List<CityMunicipality>> getCities({required Province selectedProvince}) async {
    List<CityMunicipality> cities = [];

    try {
    
     final String stringCity = await rootBundle.loadString('assets/address/citymun.json');
                  var map = jsonDecode(stringCity);
              map['loc_citymun'].forEach((var city){
      if(city['provcode'] == selectedProvince.code){
         cities.add(CityMunicipality(code: city['citymuncode'], description: city['citymundesc'], province: selectedProvince, psgcCode: city['psgccode'], zipcode: ''));
      }
      });
    } catch (e) {
      throw (e.toString());
    }
    return cities;
  }

  Future<List<Barangay>> getBarangay({required CityMunicipality cityMunicipality}) async {
    List<Barangay> barangays = [];
    String cityMuncode = cityMunicipality.code!;
    try {
        final String stringBrgy = await rootBundle.loadString('assets/address/brgy/$cityMuncode.json');
                  var map = jsonDecode(stringBrgy);
              map[cityMuncode].forEach((var brgy){
       barangays.add(Barangay(code: brgy['brgycode'], description: brgy['brgydesc'], cityMunicipality: cityMunicipality));
      });
    } catch (e) {
      throw (e.toString());
    }
    return barangays;
  }

  Future<List<Purok>> getPurok({required String barangay}) async {
    List<Purok> puroks = [];
    String path = Url.instance.getPurok() + barangay;
    try {
      http.Response response = await Request.instance
          .getRequest(path: path, param: {}, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          data['data'].forEach((var purok) {
            Purok newPurok = Purok.fromJson(purok);
            puroks.add(newPurok);
          });
        }
      }
    } catch (e) {
      throw (e.toString());
    }
    return puroks;
  }

  Future<List<AddressCategory>> getAddressCategory() async {
    List<AddressCategory> categories = [];
    String path = Url.instance.getAddressCategory();
    try {
      http.Response response = await Request.instance
          .getRequest(path: path, param: {}, headers: headers);
      Map data = jsonDecode(response.body);
      if (data['data'] != null) {
        data['data'].forEach((var cat) {
          categories.add(AddressCategory.fromJson(cat));
        });
      }
      categories;
      return categories;
    } catch (e) {
      throw e.toString();
    }
  }
}
