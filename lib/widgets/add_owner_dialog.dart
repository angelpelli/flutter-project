import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import '../models/owner.dart';
import '../viewmodels/owner_view_model.dart';

class AddOwnerDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  AddOwnerDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ownerViewModel = Provider.of<OwnerViewModel>(context, listen: false);

    return AlertDialog(
      title: const Text('Agregar nuevo dueño', style: TextStyle(color: Colors.white)),
      backgroundColor: const Color(0xFF202020),
      content: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormBuilderTextField(
                name: 'firstName',
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: FormBuilderValidators.required(),
              ),
              FormBuilderTextField(
                name: 'lastName',
                decoration: const InputDecoration(labelText: 'Apellidos'),
                validator: FormBuilderValidators.required(),
              ),
              FormBuilderTextField(
                name: 'dni',
                decoration: const InputDecoration(labelText: 'DNI'),
                validator: FormBuilderValidators.required(),
              ),
              FormBuilderTextField(
                name: 'address',
                decoration: const InputDecoration(labelText: 'Dirección'),
                validator: FormBuilderValidators.required(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Guardar', style: TextStyle(color: Color(0xFF00FFF5))),
          onPressed: () {
            if (_formKey.currentState!.saveAndValidate()) {
              final formData = _formKey.currentState!.value;
              final newOwner = Owner(
                firstName: formData['firstName'],
                lastName: formData['lastName'],
                dni: formData['dni'],
                address: formData['address'],
              );
              ownerViewModel.addOwner(newOwner);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

