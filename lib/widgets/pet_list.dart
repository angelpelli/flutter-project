import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_angel_pellitero/widgets/add_pet_dialog.dart';
import '../viewmodels/pet_view_model.dart';
import '../viewmodels/owner_view_model.dart';
import '../models/owner.dart';
import '../views/pet_detail_view.dart';

class PetList extends StatefulWidget {
  final TextEditingController searchController;

  const PetList({Key? key, required this.searchController}) : super(key: key);

  @override
  State<PetList> createState() => _PetListState();
}

class _PetListState extends State<PetList> {
  void _showAddPetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AddPetDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final petViewModel = Provider.of<PetViewModel>(context);
    final ownerViewModel = Provider.of<OwnerViewModel>(context);
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: widget.searchController,
                onChanged: (query) => petViewModel.filterPets(query),
                decoration: InputDecoration(
                  labelText: 'Buscar',
                  suffixIcon: const Icon(Icons.search, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF00FFF5)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: petViewModel.filteredPets.length,
                itemBuilder: (context, index) {
                  final pet = petViewModel.filteredPets[index];
                  final owner = ownerViewModel.owners.firstWhere((owner) => owner.id == pet.ownerId, orElse: () => Owner(firstName: 'Unknown', lastName: '', dni: '', address: ''));
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: const Color(0xFF202020),
                    child: ListTile(
                      title: Text(pet.name),
                      subtitle: Text('${pet.breed}, ${pet.age} años\nDueño: ${owner.fullName}'),
                      trailing: Text('${pet.dailyRate}€/día',
                        style: const TextStyle(color: Color(0xFF00FFF5))),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PetDetailView(pet: pet, owner: owner),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: _showAddPetDialog,
            backgroundColor: const Color(0xFF00FFF5),
            child: const Icon(Icons.add, color: Color(0xFF111111)),
          ),
        ),
      ],
    );
  }
}

