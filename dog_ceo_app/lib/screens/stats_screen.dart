import 'package:flutter/material.dart';

import '../models/dog_breed.dart';
import '../services/dog_local_database.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DogBreed> breeds = DogLocalDatabase.getBreeds();
    final favoriteBreeds = breeds.where((breed) => breed.favorite).length;
    final breedsWithSubBreeds = breeds
        .where((breed) => breed.subBreeds.isNotEmpty)
        .length;
    final cachedImages = breeds.where((breed) => breed.imageUrl != null).length;

    return Scaffold(
      appBar: AppBar(title: const Text("Statystyki")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _StatTile(title: "Wszystkie rasy", value: breeds.length.toString()),
          _StatTile(title: "Ulubione", value: favoriteBreeds.toString()),
          _StatTile(
            title: "Rasy z odmianami",
            value: breedsWithSubBreeds.toString(),
          ),
          _StatTile(title: "Zdjecia w cache", value: cachedImages.toString()),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final String value;

  const _StatTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(value, style: Theme.of(context).textTheme.headlineSmall),
      ),
    );
  }
}
