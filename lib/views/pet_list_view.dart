import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/pet_view_model.dart';
import '../viewmodels/owner_view_model.dart';
import '../models/owner.dart';
import 'pet_detail_view.dart';
import '../widgets/add_pet_dialog.dart';

class PetListView extends StatefulWidget {
  const PetListView({Key? key}) : super(key: key);

  @override
  _PetListViewState createState() => _PetListViewState();
}

class _PetListViewState extends State<PetListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PetViewModel>(context, listen: false).loadPets();
    });
  }

  @override
  Widget build(BuildContext context) {
    final petViewModel = Provider.of<PetViewModel>(context);
    final ownerViewModel = Provider.of<OwnerViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Mascotas'),
      ),
      body: Column(
        children: [
          _buildSearchField(),
          Expanded(
            child: _buildPetList(petViewModel, ownerViewModel),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPetDialog,
        backgroundColor: const Color(0xFF00FFF5),
        child: const Icon(Icons.add, color: Color(0xFF111111)),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        onChanged: (query) => Provider.of<PetViewModel>(context, listen: false).filterPets(query),
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
    );
  }

  Widget _buildPetList(PetViewModel petViewModel, OwnerViewModel ownerViewModel) {
    return ListView.builder(
      itemCount: petViewModel.filteredPets.length,
      itemBuilder: (context, index) {
        final pet = petViewModel.filteredPets[index];
        final owner = ownerViewModel.owners.firstWhere(
          (owner) => owner.id == pet.ownerId,
          orElse: () => Owner(firstName: 'Unknown', lastName: '', dni: '', address: ''),
        );
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
    );
  }

  void _showAddPetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AddPetDialog(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

