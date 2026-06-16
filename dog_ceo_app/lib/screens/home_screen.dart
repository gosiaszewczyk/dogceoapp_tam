import 'package:flutter/material.dart';

import '../models/dog_breed.dart';
import '../services/dog_local_database.dart';
import '../services/dog_sync_service.dart';
import '../widgets/breed_card.dart';
import 'breed_detail_screen.dart';
import 'favorites_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<DogBreed>> breedsFuture;
  int allBreedsCount = 0;
  int favoriteBreedsCount = 0;

  @override
  void initState() {
    super.initState();
    breedsFuture = loadBreeds();
  }

  Future<List<DogBreed>> loadBreeds() async {
    try {
      await DogSyncService.loadInitialDataIfNeeded();
      return DogLocalDatabase.getBreeds();
    } catch (error) {
      final localBreeds = DogLocalDatabase.getBreeds();

      if (localBreeds.isNotEmpty) {
        return localBreeds;
      }

      throw Exception("Brak internetu i brak danych offline");
    }
  }

  void updateCounters(List<DogBreed> breeds) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      setState(() {
        allBreedsCount = breeds.length;
        favoriteBreedsCount = breeds.where((breed) => breed.favorite).length;
      });
    });
  }

  Future<void> refreshBreeds() async {
    try {
      await DogSyncService.refreshFromApi();
      setState(() {
        breedsFuture = loadBreeds();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Dane zostaly odswiezone")),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Nie udalo sie odswiezyc danych")),
        );
      }
    }
  }

  Future<void> openDetails(DogBreed breed) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BreedDetailScreen(breed: breed)),
    );

    setState(() {
      breedsFuture = loadBreeds();
    });
  }

  Future<void> toggleFavorite(DogBreed breed, bool? value) async {
    await DogLocalDatabase.updateBreed(
      breed.copyWith(favorite: value ?? false),
    );

    setState(() {
      breedsFuture = loadBreeds();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dog CEO"),
        actions: [
          IconButton(onPressed: refreshBreeds, icon: const Icon(Icons.refresh)),
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );

              setState(() {
                breedsFuture = loadBreeds();
              });
            },
            icon: const Icon(Icons.favorite),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StatsScreen()),
              );
            },
            icon: const Icon(Icons.bar_chart),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _CounterBox(
                    title: "Rasy",
                    value: allBreedsCount.toString(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _CounterBox(
                    title: "Ulubione",
                    value: favoriteBreedsCount.toString(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<DogBreed>>(
              future: breedsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        "Blad: ${snapshot.error}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final breeds = snapshot.data ?? [];
                updateCounters(breeds);

                return RefreshIndicator(
                  onRefresh: refreshBreeds,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: breeds.length,
                    itemBuilder: (context, index) {
                      final breed = breeds[index];

                      return BreedCard(
                        breed: breed,
                        onTap: () => openDetails(breed),
                        onChanged: (value) => toggleFavorite(breed, value),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CounterBox extends StatelessWidget {
  final String title;
  final String value;

  const _CounterBox({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
    );
  }
}
