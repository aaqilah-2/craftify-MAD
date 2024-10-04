import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  // Get the local path for storing the JSON file
  Future<String> _getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Get reference to the local file
  Future<File> _getLocalFile(int userId) async {
    final path = await _getLocalPath();
    return File('$path/favorites_$userId.json'); // JSON file specific to the user
  }

  // Write favorites to a JSON file
  Future<void> writeFavorites(List<int> favoriteProductIds, int userId) async {
    final file = await _getLocalFile(userId);
    final data = jsonEncode(favoriteProductIds);
    await file.writeAsString(data);
    print('Favorites written to file for user $userId');
  }

  // Read favorites from a JSON file
  Future<List<int>> readFavorites(int userId) async {
    try {
      final file = await _getLocalFile(userId);
      if (await file.exists()) {
        final contents = await file.readAsString();
        return List<int>.from(jsonDecode(contents));
      } else {
        print('No favorites file found for user $userId. Returning empty list.');
        return [];
      }
    } catch (e) {
      print('Error reading favorites file: $e');
      return [];
    }
  }
}
