import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/stay_view_model.dart';
import '../models/pet.dart';
import '../models/stay.dart';
import '../models/owner.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class StaysView extends StatefulWidget {
  const StaysView({Key? key}) : super(key: key);

  @override
  StaysViewState createState() => StaysViewState();
}

class StaysViewState extends State<StaysView> {
  @override
  void initState() {
    super.initState();
    _loadStays();
  }

  Future<void> _loadStays() async {
    await Provider.of<StayViewModel>(context, listen: false).loadStays();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StayViewModel>(
      builder: (context, stayViewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Estancias', style: TextStyle(color: Colors.white)),
            backgroundColor: const Color(0xFF202020),
          ),
          body: ListView.builder(
            itemCount: stayViewModel.stays.length,
            itemBuilder: (context, index) {
              final stay = stayViewModel.stays[index];
              final pet = stayViewModel.pets.firstWhere((p) => p.id == stay.petId);
              final owner = stayViewModel.owners.firstWhere((o) => o.id == pet.ownerId);
              return GestureDetector(
                onLongPress: () => _showStayOptions(context, stay, pet, owner),
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(pet.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dueño: ${owner.fullName}'),
                        Text('Desde: ${DateFormat('dd/MM/yyyy').format(stay.startDate)}'),
                        Text('Hasta: ${DateFormat('dd/MM/yyyy').format(stay.endDate)}'),
                      ],
                    ),
                    trailing: Text(
                      '${stay.endDate.difference(stay.startDate).inDays} días',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showStayOptions(BuildContext context, Stay stay, Pet pet, Owner owner) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar estancia'),
              onTap: () {
                Navigator.pop(context);
                _showEditStayDialog(context, stay, pet);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Eliminar estancia'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmationDialog(context, stay);
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditStayDialog(BuildContext context, Stay stay, Pet pet) {
    final stayViewModel = Provider.of<StayViewModel>(context, listen: false);
    DateTime? rangeStart = stay.startDate;
    DateTime? rangeEnd = stay.endDate;
    DateTime focusedDay = stay.startDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Editar Estancia', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 16),
                        Text('Mascota: ${pet.name}'),
                        const SizedBox(height: 16),
                        TableCalendar(
                          firstDay: DateTime.now().subtract(const Duration(days: 365)),
                          lastDay: DateTime.now().add(const Duration(days: 365)),
                          focusedDay: focusedDay,
                          selectedDayPredicate: (day) =>
                              isSameDay(rangeStart, day) || isSameDay(rangeEnd, day),
                          rangeStartDay: rangeStart,
                          rangeEndDay: rangeEnd,
                          calendarFormat: CalendarFormat.month,
                          rangeSelectionMode: RangeSelectionMode.enforced,
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          onRangeSelected: (start, end, focusedDay) {
                            setState(() {
                              rangeStart = start;
                              rangeEnd = end;
                              focusedDay = focusedDay;
                            });
                          },
                          onPageChanged: (focusedDay) {
                            focusedDay = focusedDay;
                          },
                          calendarStyle: const CalendarStyle(
                            defaultTextStyle: TextStyle(color: Colors.white),
                            weekendTextStyle: TextStyle(color: Colors.white70),
                            holidayTextStyle: TextStyle(color: Colors.white),
                            selectedTextStyle: TextStyle(color: Colors.black),
                            todayTextStyle: TextStyle(color: Colors.black),
                            outsideTextStyle: TextStyle(color: Colors.white54),
                            rangeStartTextStyle: TextStyle(color: Colors.black),
                            rangeEndTextStyle: TextStyle(color: Colors.black),
                            disabledTextStyle: TextStyle(color: Colors.grey),
                            selectedDecoration: BoxDecoration(
                              color: Color(0xFF00FFF5),
                              shape: BoxShape.circle,
                            ),
                            todayDecoration: BoxDecoration(
                              color: Color(0xFFFFE605),
                              shape: BoxShape.circle,
                            ),
                            rangeStartDecoration: BoxDecoration(
                              color: Color(0xFF00FFF5),
                              shape: BoxShape.circle,
                            ),
                            rangeEndDecoration: BoxDecoration(
                              color: Color(0xFF00FFF5),
                              shape: BoxShape.circle,
                            ),
                            rangeHighlightColor: Color(0xFF00FFF5),
                          ),
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
                            leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                            rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
                          ),
                          daysOfWeekStyle: const DaysOfWeekStyle(
                            weekdayStyle: TextStyle(color: Colors.white),
                            weekendStyle: TextStyle(color: Colors.white70),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              child: const Text('Cancelar'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            TextButton(
                              child: const Text('Guardar'),
                              onPressed: () {
                                if (rangeStart != null && rangeEnd != null) {
                                  final updatedStay = Stay(
                                    id: stay.id,
                                    petId: stay.petId,
                                    startDate: rangeStart!,
                                    endDate: rangeEnd!,
                                  );
                                  stayViewModel.updateStay(updatedStay);
                                  Navigator.of(context).pop();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Por favor, selecciona fechas válidas')),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Stay stay) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Estás seguro de que quieres eliminar esta estancia?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                Provider.of<StayViewModel>(context, listen: false).deleteStay(stay.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

