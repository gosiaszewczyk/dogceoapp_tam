import 'package:flutter/material.dart';

import '../models/dog_breed.dart';
import '../services/dog_api_service.dart';
import '../services/dog_local_database.dart';

class BreedDetailScreen extends StatefulWidget {
  final DogBreed breed;

  const BreedDetailScreen({super.key, required this.breed});

  @override
  State<BreedDetailScreen> createState() => _BreedDetailScreenState();
}

class _BreedDetailScreenState extends State<BreedDetailScreen> {
  late DogBreed breed;
  late Future<String> imageFuture;

  @override
  void initState() {
    super.initState();
    breed = widget.breed;
    imageFuture = loadImage();
  }

  Future<String> loadImage() async {
    if (breed.imageUrl != null) {
      return breed.imageUrl!;
    }

    final imageUrl = await DogApiService.fetchRandomImage(breed.name);
    breed = breed.copyWith(imageUrl: imageUrl);
    await DogLocalDatabase.updateBreed(breed);
    return imageUrl;
  }

  Future<void> refreshImage() async {
    setState(() {
      imageFuture = DogApiService.fetchRandomImage(breed.name).then((
        imageUrl,
      ) async {
        breed = breed.copyWith(imageUrl: imageUrl);
        await DogLocalDatabase.updateBreed(breed);
        return imageUrl;
      });
    });
  }

  Future<void> toggleFavorite(bool? value) async {
    breed = breed.copyWith(favorite: value ?? false);
    await DogLocalDatabase.updateBreed(breed);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final subBreeds = breed.subBreeds.isEmpty
        ? "Brak odmian"
        : breed.subBreeds.join(", ");

    return Scaffold(
      appBar: AppBar(
        title: Text(breed.name),
        actions: [
          IconButton(onPressed: refreshImage, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FutureBuilder<String>(
            future: imageFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 260,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return Container(
                  height: 220,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.errorContainer,
                  ),
                  child: const Text("Nie udalo sie pobrac zdjecia"),
                );
              }

              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  snapshot.data!,
                  height: 280,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: breed.favorite,
                        onChanged: toggleFavorite,
                      ),
                      const Text("Ulubiona rasa"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text("Nazwa", style: Theme.of(context).textTheme.labelLarge),
                  Text(
                    breed.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Odmiany",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Text(subBreeds),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
