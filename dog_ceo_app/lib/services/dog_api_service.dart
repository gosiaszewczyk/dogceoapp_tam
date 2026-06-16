import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/dog_breed.dart';

class DogApiService {
  static const String baseUrl = "https://dog.ceo/api";

  static Future<List<DogBreed>> fetchBreeds() async {
    final response = await http.get(Uri.parse("$baseUrl/breeds/list/all"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final Map<String, dynamic> message = data["message"];

      return message.entries.map((entry) {
        return DogBreed(
          name: entry.key,
          subBreeds: List<String>.from(entry.value),
        );
      }).toList();
    } else {
      throw Exception("Nie udalo sie pobrac listy ras");
    }
  }

  static Future<String> fetchRandomImage(String breed) async {
    final response = await http.get(
      Uri.parse("$baseUrl/breed/$breed/images/random"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["message"];
    } else {
      throw Exception("Nie udalo sie pobrac zdjecia");
    }
  }
}
