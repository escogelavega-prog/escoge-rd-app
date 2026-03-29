import 'dart:convert';
import 'package:escoge/features/oracion/data/models/evangelio_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class EvangelioService {
  static const String baseUrl = 'https://tu-api.com/evangelio';

  Future<EvangelioModel> getEvangelio() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return EvangelioModel.fromJson(data);
    } else {
      throw Exception('Error al cargar el evangelio');
    }
  }
}
