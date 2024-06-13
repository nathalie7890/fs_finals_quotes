import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteService {
  static const String _baseUrl = 'https://fcapi-1y70.onrender.com';

  Future<Map<String, String>> fetchRandomQuote() async {
    final response = await http.get(Uri.parse('$_baseUrl/quotes/random'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'id': data['id'].toString(),
        'quote': data['quote'],
        'author': data['author'],
      };
    } else {
      throw Exception('Failed to load quote');
    }
  }

  Future<List<Map<String, String>>> fetchQuotes() async {
    final response = await http.get(Uri.parse('$_baseUrl/quotes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Map<String, String>> quotes = data.map((quote) {
        return {
          'id': quote['id'].toString(),
          'quote': quote['quote'].toString(),
          'author': quote['author'].toString(),
        };
      }).toList();
      return quotes;
    } else {
      throw Exception('Failed to load quotes');
    }
  }

  Future<Map<String, String>> fetchQuoteById(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/quotes/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'id': data['id'].toString(),
        'quote': data['quote'].toString(),
        'author': data['author'].toString(),
      };
    } else {
      throw Exception('Failed to load quote');
    }
  }
}
