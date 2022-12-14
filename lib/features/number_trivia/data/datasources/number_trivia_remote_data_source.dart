import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/number_trivia.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint
  ///
  /// Throws a [ServerException] for all error codes
  Future<NumberTrivia> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint
  ///
  /// Throws a [ServerException] for all error codes
  Future<NumberTrivia> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;
  NumberTriviaRemoteDataSourceImpl({required this.client});
  @override
  Future<NumberTrivia> getConcreteNumberTrivia(int number) =>
      _getTriviaFromUrl('http://numbersapi.com/$number');

  @override
  Future<NumberTrivia> getRandomNumberTrivia() => _getTriviaFromUrl('http://numbersapi.com/random');

  Future<NumberTrivia> _getTriviaFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      print('BODYYY: ${response.body}');
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
