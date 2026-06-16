class DogBreed {
  final String name;
  final List<String> subBreeds;
  final bool favorite;
  final String? imageUrl;

  DogBreed({
    required this.name,
    required this.subBreeds,
    this.favorite = false,
    this.imageUrl,
  });

  String get title {
    if (subBreeds.isEmpty) {
      return name;
    }
    return "$name (${subBreeds.length})";
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "subBreeds": subBreeds,
      "favorite": favorite,
      "imageUrl": imageUrl,
    };
  }

  factory DogBreed.fromMap(Map<String, dynamic> map) {
    final rawSubBreeds = map["subBreeds"] ?? [];

    return DogBreed(
      name: map["name"],
      subBreeds: List<String>.from(rawSubBreeds),
      favorite: map["favorite"] ?? false,
      imageUrl: map["imageUrl"],
    );
  }

  DogBreed copyWith({
    String? name,
    List<String>? subBreeds,
    bool? favorite,
    String? imageUrl,
  }) {
    return DogBreed(
      name: name ?? this.name,
      subBreeds: subBreeds ?? this.subBreeds,
      favorite: favorite ?? this.favorite,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
