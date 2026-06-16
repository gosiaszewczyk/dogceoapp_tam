import 'dog_api_service.dart';
import 'dog_local_database.dart';

class DogSyncService {
  static Future<void> loadInitialDataIfNeeded() async {
    if (!DogLocalDatabase.isEmpty()) {
      return;
    }

    final breeds = await DogApiService.fetchBreeds();
    await DogLocalDatabase.saveBreeds(breeds);
  }

  static Future<void> refreshFromApi() async {
    final localBreeds = DogLocalDatabase.getBreeds();
    final freshBreeds = await DogApiService.fetchBreeds();

    final mergedBreeds = freshBreeds.map((breed) {
      final oldBreed = localBreeds.where((item) => item.name == breed.name);

      if (oldBreed.isEmpty) {
        return breed;
      }

      return breed.copyWith(
        favorite: oldBreed.first.favorite,
        imageUrl: oldBreed.first.imageUrl,
      );
    }).toList();

    await DogLocalDatabase.saveBreeds(mergedBreeds);
  }
}
