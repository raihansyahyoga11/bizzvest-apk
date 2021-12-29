import 'dart:convert';
import 'package:bizzvest/faq/models/question.dart';
import 'package:http/http.dart' as http;

Future<List<Question>?> fetchQuestion() async {
  final response = await http.get(Uri.parse('http://bizzvest.herokuapp.com/faq/json/'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return parseItem(response.body);
  } else {
    // If the server did not return a 200 OK response,d
    // then throw an exception.
    throw Exception('Failed to load Get');
  }
}

List<Question>? parseItem(String responseBody) {
  final List<Question> questions = [];
  final parsed = jsonDecode(responseBody) as List<dynamic>;
  for (var e in parsed) {
    questions.add(Question.fromJson(e));
  }

  return questions;
}
