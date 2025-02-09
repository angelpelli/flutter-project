import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/owner_view_model.dart';
import '../viewmodels/pet_view_model.dart';
import '../views/pet_detail_view.dart';

class OwnerList extends StatelessWidget {
  final TextEditingController searchController;

  const OwnerList({Key? key, required this.searchController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ownerViewModel = Provider.of<OwnerViewModel>(context);
    final petViewModel = Provider.of<PetViewModel>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            onChanged: (query) => ownerViewModel.filterOwners(query),
            decoration: InputDecoration(
              labelText: 'Buscar dueño',
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
            itemCount: ownerViewModel.filteredOwners.length,
            itemBuilder: (context, index) {
              final owner = ownerViewModel.filteredOwners[index];
              final ownerPets = petViewModel.pets.where((pet) => pet.ownerId == owner.id).toList();
              return ExpansionTile(
                title: Text(owner.fullName),
                subtitle: Text('DNI: ${owner.dni}'),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dirección: ${owner.address}'),
                        const SizedBox(height: 8),
                        const Text('Mascotas:'),
                        ...ownerPets.map((pet) => ListTile(
                          title: Text(pet.name),
                          subtitle: Text(pet.breed),
                          trailing: Text('${pet.dailyRate}€/día',
                            style: const TextStyle(color: Color(0xFF00FFF5))),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PetDetailView(pet: pet, owner: owner),
                            ),
                          ),
                        )).toList(),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

