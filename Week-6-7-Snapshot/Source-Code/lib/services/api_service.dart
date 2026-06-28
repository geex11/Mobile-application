import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  static const String _baseUrl = 'https://dev.to/api';

  static Future<List<Post>> fetchPosts() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/articles?per_page=30&tag=mobile'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on HttpException {
      throw Exception('Could not reach the server. Try again later.');
    } on FormatException {
      throw Exception('Invalid response from server.');
    }
  }
}
