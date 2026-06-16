import 'package:flutter/material.dart';

import '../models/dog_breed.dart';

class BreedCard extends StatelessWidget {
  final DogBreed breed;
  final VoidCallback onTap;
  final ValueChanged<bool?> onChanged;

  const BreedCard({
    super.key,
    required this.breed,
    required this.onTap,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = breed.subBreeds.isEmpty
        ? "Brak odmian"
        : "Odmiany: ${breed.subBreeds.join(", ")}";

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(value: breed.favorite, onChanged: onChanged),
        title: Text(
          breed.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
