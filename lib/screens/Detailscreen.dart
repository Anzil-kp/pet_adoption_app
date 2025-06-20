import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../bloc/pet_bloc.dart';
import '../bloc/pet_event.dart';
import '../pet_model.dart';

class DetailScreen extends StatefulWidget {
  final Pet pet;

  const DetailScreen({super.key, required this.pet});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _adoptPet() {
    if (widget.pet.isAdopted) return;

    setState(() {
      widget.pet.isAdopted = true;
    });

    context.read<PetBloc>().add(AdoptPet(widget.pet.id));
    _confettiController.play();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("You’ve now adopted ${widget.pet.name}!")),
    );
  }

  void _openZoomView() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(widget.pet.name)),
          body: Center(
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(widget.pet.imageUrl),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pet = widget.pet;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(pet.name, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade300,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _openZoomView,
                  child: Hero(
                    tag: pet.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: pet.imageUrl,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image, size: 80),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Grid-like information cards
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _infoTile("Breed", pet.breed),
                    _infoTile("Age", "${pet.age} yrs"),
                    _infoTile("Gender", pet.gender),
                    _infoTile("Price", "₹${pet.price.toInt()}"),
                  ],
                ),

                const SizedBox(height: 30),

                // Adopt Button
                ElevatedButton.icon(
                  icon: const Icon(Icons.pets, color: Colors.white),
                  label: Text(
                    pet.isAdopted ? "Already Adopted" : "Adopt Me",
                    style: const TextStyle(color: Colors.white),
                  ),
                  onPressed: pet.isAdopted ? null : _adoptPet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    pet.isAdopted ? Colors.grey : Colors.green.shade300,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 30,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              gravity: 0.1,
              shouldLoop: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 28,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}