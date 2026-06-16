import 'package:dog_ceo_app/models/dog_breed.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("DogBreed maps data correctly", () {
    final breed = DogBreed(
      name: "hound",
      subBreeds: ["afghan", "basset"],
      favorite: true,
      imageUrl: "https://example.com/dog.jpg",
    );

    final mappedBreed = DogBreed.fromMap(breed.toMap());

    expect(mappedBreed.name, "hound");
    expect(mappedBreed.subBreeds.length, 2);
    expect(mappedBreed.favorite, true);
    expect(mappedBreed.imageUrl, "https://example.com/dog.jpg");
  });
}
