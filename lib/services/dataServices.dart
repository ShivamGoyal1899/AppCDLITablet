import 'dart:async';

import 'package:cdlitablet/model/cdliModel.dart';
import 'package:http/http.dart' as http;

class ApiResponse {
  Future<List<Cdli>> getCDLI() async {
    String url = 'https://cdli.ucla.edu/cdlitablet_android/fetchdata';
    final response = await http.get(url);
    return cdliFromJson(response.body);
  }
}
