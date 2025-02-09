import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/owner_view_model.dart';
import '../viewmodels/pet_view_model.dart';
import 'pet_detail_view.dart';
import '../widgets/add_owner_dialog.dart';

class OwnerListView extends StatefulWidget {
  const OwnerListView({Key? key}) : super(key: key);

  @override
  _OwnerListViewState createState() => _OwnerListViewState();
}

class _OwnerListViewState extends State<OwnerListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OwnerViewModel>(context, listen: false).loadOwners();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ownerViewModel = Provider.of<OwnerViewModel>(context);
    final petViewModel = Provider.of<PetViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Dueños'),
      ),
      body: Column(
        children: [
          _buildSearchField(),
          Expanded(
            child: _buildOwnerList(ownerViewModel, petViewModel),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddOwnerDialog,
        backgroundColor: const Color(0xFF00FFF5),
        child: const Icon(Icons.person_add, color: Color(0xFF111111)),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        onChanged: (query) => Provider.of<OwnerViewModel>(context, listen: false).filterOwners(query),
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
    );
  }

  Widget _buildOwnerList(OwnerViewModel ownerViewModel, PetViewModel petViewModel) {
    return ListView.builder(
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
    );
  }

  void _showAddOwnerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AddOwnerDialog(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

