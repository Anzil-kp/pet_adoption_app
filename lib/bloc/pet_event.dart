abstract class PetEvent {}

class LoadPets extends PetEvent {}

class SearchPets extends PetEvent {
  final String query;
  SearchPets(this.query);
}
class AdoptPet extends PetEvent {
  final String petId;
  AdoptPet(this.petId);
}
class ToggleFavorite extends PetEvent {
  final String petId;
  ToggleFavorite(this.petId);
}