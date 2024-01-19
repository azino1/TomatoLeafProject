import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiServices {
  ///Makes a api call to the Ml server
  static Future<String> predictPlantDisease(String xFilePath) async {
    final headers = {
      'Content-Type': 'multipart/form-data',
    };
    try {
      print("1");
      final multiPartFile =
          await http.MultipartFile.fromPath('image', xFilePath);
      print("2");
      var request = http.MultipartRequest(
          'POST', Uri.parse("http://209.145.54.217:8000/predict"))
        // ..fields.addAll(_body)
        ..headers.addAll(headers)
        ..files.add(multiPartFile);
      print("3");

      final response = await http.Response.fromStream(await request.send());
      print("4");

      final responseData = json.decode(response.body);
      print("5");

      if (!(response.statusCode >= 200 && response.statusCode < 290)) {
        throw const HttpException("Network error while scanning");
      }

      print(responseData);

      return responseData['prediction'];
    } catch (e) {
      rethrow;
    }
  }
}
