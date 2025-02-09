import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pet.dart';
import '../models/stay.dart';
import '../models/owner.dart'; // Import the Owner model
import '../viewmodels/pet_view_model.dart';


// ignore: must_be_immutable
class PetDetailView extends StatefulWidget {
  Pet pet;
  final Owner owner;

  PetDetailView({Key? key, required this.pet, required this.owner}) : super(key: key);

  @override
  PetDetailViewState createState() => PetDetailViewState();
}

class PetDetailViewState extends State<PetDetailView> {
  List<Stay> _stays = [];

  @override
  void initState() {
    super.initState();
    _loadStays();
  }

  Future<void> _loadStays() async {
    final stays = await Provider.of<PetViewModel>(context, listen: false).getStaysForPet(widget.pet.id);
    setState(() {
      _stays = stays;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dueño: ${widget.owner.fullName}', style: Theme.of(context).textTheme.titleLarge),
              Text('DNI del dueño: ${widget.owner.dni}', style: Theme.of(context).textTheme.titleMedium),
              Text('Dirección del dueño: ${widget.owner.address}', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              Text('Raza: ${widget.pet.breed}', style: Theme.of(context).textTheme.titleMedium),
              Text('Edad: ${widget.pet.age} años', style: Theme.of(context).textTheme.titleMedium),
              Text('Tarifa diaria: ${widget.pet.dailyRate}€', style: Theme.of(context).textTheme.titleMedium),
              Text('Microchip: ${widget.pet.microchip}', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              Text('Descripción:', style: Theme.of(context).textTheme.titleLarge),
              Text(widget.pet.description, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              Text('Estancias:', style: Theme.of(context).textTheme.titleLarge),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _stays.length,
                itemBuilder: (context, index) {
                  final stay = _stays[index];
                  return ListTile(
                    title: Text('${stay.startDate.toLocal()} - ${stay.endDate.toLocal()}'),
                    subtitle: Text('Duración: ${stay.endDate.difference(stay.startDate).inDays} días'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditPetDialog(context),
        child: const Icon(Icons.edit),
      ),
    );
  }

  void _showEditPetDialog(BuildContext context) {
    final _nameController = TextEditingController(text: widget.pet.name);
    final _breedController = TextEditingController(text: widget.pet.breed);
    final _ageController = TextEditingController(text: widget.pet.age.toString());
    final _rateController = TextEditingController(text: widget.pet.dailyRate.toString());
    final _descriptionController = TextEditingController(text: widget.pet.description);
    final _microchipController = TextEditingController(text: widget.pet.microchip);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Mascota'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: _breedController,
                  decoration: const InputDecoration(labelText: 'Raza'),
                ),
                TextField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Edad'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _rateController,
                  decoration: const InputDecoration(labelText: 'Tarifa Diaria'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  maxLines: 3,
                ),
                TextField(
                  controller: _microchipController,
                  decoration: const InputDecoration(labelText: 'Número de Microchip'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () async {
                final updatedPet = Pet(
                  id: widget.pet.id,
                  name: _nameController.text,
                  ownerId: widget.owner.id,
                  breed: _breedController.text,
                  age: int.parse(_ageController.text),
                  dailyRate: double.parse(_rateController.text),
                  description: _descriptionController.text,
                  microchip: _microchipController.text,
                );
                await Provider.of<PetViewModel>(context, listen: false).updatePet(updatedPet);
                Navigator.of(context).pop();
                setState(() {
                  widget.pet = updatedPet;
                });
                _loadStays();
              },
            ),
          ],
        );
      },
    );
  }
}

