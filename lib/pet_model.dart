class Pet {
  final String id;
  final String name;
  final String imageUrl;
  final String breed;
  final int age;
  final String gender;
  final double price;

  bool isAdopted;
  bool isFavorite;

  Pet({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.breed,
    required this.age,
    required this.gender,
    required this.price,
    this.isAdopted = false,
    this.isFavorite = false,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unnamed',
      imageUrl: json['image'] ?? '',
      breed: json['breed'] ?? 'Unknown',
      age: json['age'] is int ? json['age'] : int.tryParse(json['age'].toString()) ?? 0,
      gender: json['gender'] ?? 'Unknown',
      price: (json['price'] ?? 0).toDouble(),
      isAdopted: json['isAdopted'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': imageUrl,
    'breed': breed,
    'age': age,
    'gender': gender,
    'price': price,
    'isAdopted': isAdopted,
    'isFavorite': isFavorite,
  };
}