import 'dart:convert';
import 'dart:io'; // For SocketException
import 'package:hexolt/core/constants.dart';
import 'package:http/http.dart' as http;

class ApiService {

  static const String apiUrl = Constants.baseUrl;

  Future<List<dynamic>> fetchPosts() async {
    try {

      final http.Response response = await http.get(Uri.parse(apiUrl));


      if (response.statusCode >= 200 && response.statusCode < 300) {

        return json.decode(utf8.decode(response.bodyBytes));
      } else if (response.statusCode == 400) {
        throw Exception('Bad Request: ${response.statusCode}');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: ${response.statusCode}');
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden: ${response.statusCode}');
      } else if (response.statusCode == 404) {
        throw Exception('Not Found: ${response.statusCode}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal Server Error: ${response.statusCode}');
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {

        print('No Internet connection: $e');
      } else {

        print('Error occurred: $e');
      }
      return [];
    }
  }
}
