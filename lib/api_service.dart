import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'https://mindicador.cl/api/uf';

  static Future<double> getUfValue() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['serie'][0]['valor'];
    } else {
      throw Exception('Error al obtener el valor de la UF');
    }
  }
}
