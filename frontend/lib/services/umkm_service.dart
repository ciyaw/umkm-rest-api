import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/umkm.dart';

class UmkmService {
  final String url = '$baseUrl/umkm';
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<List<Umkm>> getAll() async {
    final res = await http.get(Uri.parse(url), headers: headers);
    final body = jsonDecode(res.body);
    if (res.statusCode == 200) {
      final List data = body['data'];
      return data.map((e) => Umkm.fromJson(e)).toList();
    }
    throw Exception(body['message']);
  }

  Future<Map<String, dynamic>> create(Umkm umkm) async {
    final res = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(umkm.toJson()),
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> update(int id, Umkm umkm) async {
    final res = await http.put(
      Uri.parse('$url/$id'),
      headers: headers,
      body: jsonEncode(umkm.toJson()),
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> delete(int id) async {
    final res = await http.delete(Uri.parse('$url/$id'), headers: headers);
    return jsonDecode(res.body);
  }
}