import 'package:flutter/material.dart';
import '../services/local_storage_service.dart'; // The new local storage service

class FavoritesManager with ChangeNotifier {
  List<int> _favoriteProductIds = [];
  int? _userId;
  final LocalStorageService _storageService = LocalStorageService();

  List<int> get favoriteProductIds => _favoriteProductIds;

  // Load user-specific favorites from local storage when the manager is initialized
  FavoritesManager();

  // Set the user ID and load favorites for that user
  Future<void> setUser(int userId) async {
    _userId = userId;
    await loadFavoritesFromLocal();  // Load user-specific favorites when the user is set
  }

  Future<void> loadFavoritesFromLocal() async {
    if (_userId != null) {
      _favoriteProductIds = await _storageService.readFavorites(_userId!);
      print('Loaded favorites for user $_userId: $_favoriteProductIds');
      notifyListeners();
    }
  }

  Future<void> _saveFavoritesToLocal() async {
    if (_userId != null) {
      await _storageService.writeFavorites(_favoriteProductIds, _userId!);
      print('Favorites saved for user $_userId');
    }
  }

  bool isFavorite(int productId) {
    return _favoriteProductIds.contains(productId);
  }

  // Add or remove the product from favorites and save it to local storage
  void toggleFavorite(int productId) {
    if (isFavorite(productId)) {
      _favoriteProductIds.remove(productId);
      print('Removed from favorites: $productId');
    } else {
      _favoriteProductIds.add(productId);
      print('Added to favorites: $productId');
    }
    _saveFavoritesToLocal(); // Save the updated list
    notifyListeners();
  }
}
