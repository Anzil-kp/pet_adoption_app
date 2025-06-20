import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pet_adoption_app/pet_model.dart';

class PetRepository {
  final String apiUrl =
      'https://raw.githubusercontent.com/Anzil-kp/Petadoptiondata/refs/heads/main/Pets.JSON';

  Future<List<Pet>> fetchPets({String query = ''}) async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Parse and filter by search query
        List<Pet> pets = data.map((json) => Pet.fromJson(json)).toList();

        if (query.isNotEmpty) {
          pets = pets
              .where((pet) =>
              pet.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
        }

        // Optional: Debug image URLs
        for (final pet in pets) {
          print(' ${pet.name} image: ${pet.imageUrl}');
        }

        return pets;
      } else {
        throw Exception('Failed to load pets: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching pets: $e');
    }
  }
}