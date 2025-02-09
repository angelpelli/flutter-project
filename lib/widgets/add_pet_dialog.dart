import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import '../models/pet.dart';
import '../viewmodels/pet_view_model.dart';
import '../viewmodels/owner_view_model.dart';

class AddPetDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  AddPetDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final petViewModel = Provider.of<PetViewModel>(context, listen: false);
    final ownerViewModel = Provider.of<OwnerViewModel>(context, listen: false);

    return AlertDialog(
      title: Text('Agregar nueva mascota', style: TextStyle(color: Colors.white)),
      backgroundColor: Color(0xFF202020),
      content: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormBuilderDropdown<String>(
                name: 'ownerId',
                decoration: InputDecoration(labelText: 'Dueño'),
                items: ownerViewModel.owners
                    .map((owner) => DropdownMenuItem(
                          value: owner.id,
                          child: Text(owner.fullName),
                        ))
                    .toList(),
                validator: FormBuilderValidators.required(),
              ),
              FormBuilderTextField(
                name: 'name',
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: FormBuilderValidators.required(),
              ),
              FormBuilderTextField(
                name: 'breed',
                decoration: InputDecoration(labelText: 'Raza'),
                validator: FormBuilderValidators.required(),
              ),
              FormBuilderTextField(
                name: 'age',
                decoration: InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                ]),
              ),
              FormBuilderTextField(
                name: 'dailyRate',
                decoration: InputDecoration(labelText: 'Tarifa diaria'),
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                ]),
              ),
              FormBuilderTextField(
                name: 'description',
                decoration: InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
              ),
              FormBuilderTextField(
                name: 'microchip',
                decoration: InputDecoration(labelText: 'Número de Microchip'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancelar', style: TextStyle(color: Colors.white)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('Guardar', style: TextStyle(color: Color(0xFF00FFF5))),
          onPressed: () {
            if (_formKey.currentState!.saveAndValidate()) {
              final formData = _formKey.currentState!.value;
              final newPet = Pet(
                name: formData['name'],
                ownerId: formData['ownerId'],
                breed: formData['breed'],
                age: int.parse(formData['age']),
                dailyRate: double.parse(formData['dailyRate']),
                description: formData['description'] ?? '',
                microchip: formData['microchip'] ?? '',
              );
              petViewModel.addPet(newPet);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

