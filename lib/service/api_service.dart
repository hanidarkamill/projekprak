import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projek3/model/cake_model.dart';

class ApiService {
  Future<CakeModel> fetchCakeData({required String query}) async {
    final response = await http.get(Uri.parse(
        'https://gist.githubusercontent.com/prayagKhanal/8cdd00d762c48b84a911eca2e2eb3449/raw/5c5d62797752116799aacaeeef08ea2d613569e9/cakes.json'));

    if (response.statusCode == 200) {
      return CakeModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load cake data');
    }
  }
}
