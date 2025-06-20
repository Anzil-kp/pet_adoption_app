import 'package:flutter_bloc/flutter_bloc.dart';

import '../PetRepository.dart';
import '../pet_model.dart';
import '../utlis/sharedPref.dart';
import 'pet_event.dart';
import 'pet_state.dart';

class PetBloc extends Bloc<PetEvent, PetState> {
  final PetRepository repository;
  List<Pet> _allPets = [];

  PetBloc(this.repository) : super(PetInitial()) {
    on<LoadPets>(_onLoadPets);
    on<SearchPets>(_onSearchPets);
    on<AdoptPet>(_onAdoptPet);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  /// Loads all pets and sets isAdopted and isFavorite based on saved local data
  void _onLoadPets(LoadPets event, Emitter<PetState> emit) async {
    emit(PetLoading());
    try {
      _allPets = await repository.fetchPets();

      final adoptedIds = await SharedPrefsHelper.getAdoptedPets();
      final favoriteIds = await SharedPrefsHelper.getFavoritePets();

      for (var pet in _allPets) {
        if (adoptedIds.contains(pet.id)) {
          pet.isAdopted = true;
        }
        if (favoriteIds.contains(pet.id)) {
          pet.isFavorite = true;
        }
      }

      emit(PetLoaded(_allPets));
    } catch (e) {
      emit(PetError('Failed to fetch pets: ${e.toString()}'));
    }
  }

  /// Search pets by name
  void _onSearchPets(SearchPets event, Emitter<PetState> emit) {
    final query = event.query.toLowerCase();
    final filtered = _allPets
        .where((pet) => pet.name.toLowerCase().contains(query))
        .toList();
    emit(PetLoaded(filtered));
  }

  /// Adopt a pet and save adoption status
  void _onAdoptPet(AdoptPet event, Emitter<PetState> emit) async {
    final index = _allPets.indexWhere((p) => p.id == event.petId);
    if (index != -1 && !_allPets[index].isAdopted) {
      _allPets[index].isAdopted = true;
      await SharedPrefsHelper.saveAdoptedPet(event.petId);
      emit(PetLoaded(List.from(_allPets)));
    }
  }

  /// Toggle favorite status and persist
  void _onToggleFavorite(ToggleFavorite event, Emitter<PetState> emit) async {
    final index = _allPets.indexWhere((p) => p.id == event.petId);
    if (index != -1) {
      final pet = _allPets[index];
      pet.isFavorite = !pet.isFavorite;
      await SharedPrefsHelper.toggleFavorite(pet.id, pet.isFavorite);
      emit(PetLoaded(List.from(_allPets)));
    }
  }
}