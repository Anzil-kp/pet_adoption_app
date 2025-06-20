import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String adoptedKey = 'adopted_pets';

  static Future<void> saveAdoptedPet(String petId) async {
    final prefs = await SharedPreferences.getInstance();
    final adopted = prefs.getStringList(adoptedKey) ?? [];
    if (!adopted.contains(petId)) {
      adopted.add(petId);
      await prefs.setStringList(adoptedKey, adopted);
    }
  }

  static Future<List<String>> getAdoptedPets() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(adoptedKey) ?? [];
  }

  static const String favoriteKey = 'favorite_pets';

  static Future<void> toggleFavorite(String petId, bool isFav) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(favoriteKey) ?? [];

    if (isFav) {
      if (!list.contains(petId)) list.add(petId);
    } else {
      list.remove(petId);
    }

    await prefs.setStringList(favoriteKey, list);
  }

  static Future<List<String>> getFavoritePets() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(favoriteKey) ?? [];
  }
}