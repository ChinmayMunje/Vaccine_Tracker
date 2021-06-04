import 'dart:convert';

import 'package:http/http.dart' as http;

class AppServices{

  Future<dynamic> getPinCode(String pinCode, String date) async {
    String pinCodeUrl = "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=$pinCode&date=$date";
    final response = await http.get(pinCodeUrl);
    var responseData = jsonDecode(response.body);
    return responseData;
  }
}