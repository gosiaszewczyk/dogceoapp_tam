import 'package:flutter/material.dart';

import '../models/dog_breed.dart';
import '../services/dog_local_database.dart';
import '../widgets/breed_card.dart';
import 'breed_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<DogBreed>> favoritesFuture;

  @override
  void initState() {
    super.initState();
    favoritesFuture = loadFavorites();
  }

  Future<List<DogBreed>> loadFavorites() async {
    return DogLocalDatabase.getBreeds()
        .where((breed) => breed.favorite)
        .toList();
  }

  Future<void> openDetails(DogBreed breed) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BreedDetailScreen(breed: breed)),
    );

    setState(() {
      favoritesFuture = loadFavorites();
    });
  }

  Future<void> toggleFavorite(DogBreed breed, bool? value) async {
    await DogLocalDatabase.updateBreed(
      breed.copyWith(favorite: value ?? false),
    );

    setState(() {
      favoritesFuture = loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ulubione")),
      body: FutureBuilder<List<DogBreed>>(
        future: favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Blad: ${snapshot.error}"));
          }

          final breeds = snapshot.data ?? [];

          if (breeds.isEmpty) {
            return const Center(child: Text("Brak ulubionych ras"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: breeds.length,
            itemBuilder: (context, index) {
              final breed = breeds[index];

              return BreedCard(
                breed: breed,
                onTap: () => openDetails(breed),
                onChanged: (value) => toggleFavorite(breed, value),
              );
            },
          );
        },
      ),
    );
  }
}
