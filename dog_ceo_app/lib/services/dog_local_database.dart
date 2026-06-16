import 'package:hive_ce/hive.dart';

import '../models/dog_breed.dart';

class DogLocalDatabase {
  static Box get _box => Hive.box("breeds");

  static List<DogBreed> getBreeds() {
    return _box.values.map((item) {
      return DogBreed.fromMap(Map<String, dynamic>.from(item));
    }).toList();
  }

  static Future<void> saveBreeds(List<DogBreed> breeds) async {
    await _box.clear();

    for (final breed in breeds) {
      await _box.put(breed.name, breed.toMap());
    }
  }

  static Future<void> updateBreed(DogBreed breed) async {
    await _box.put(breed.name, breed.toMap());
  }

  static bool isEmpty() {
    return _box.isEmpty;
  }
}
