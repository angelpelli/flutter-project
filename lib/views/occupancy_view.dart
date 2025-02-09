import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../models/stay.dart';
import '../components/kennel_grid.dart';
import '../components/occupancy_indicator.dart';
import 'package:table_calendar/table_calendar.dart';
import '../database/database_helper.dart';
import '../responsive_layout.dart';
import 'package:provider/provider.dart';
import '../viewmodels/occupancy_view_model.dart';

class OccupancyView extends StatefulWidget {
  const OccupancyView({Key? key}) : super(key: key);

  @override
  OccupancyViewState createState() => OccupancyViewState();
}

class OccupancyViewState extends State<OccupancyView> {
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  Pet? _selectedPet;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    Provider.of<OccupancyViewModel>(context, listen: false).loadOccupancy();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OccupancyViewModel>(
      builder: (context, occupancyViewModel, child) {
        return SingleChildScrollView(
          child: Container(
            color: const Color(0xFF111111),
            child: Column(
              children: [
                ResponsiveLayout(
                  mobile: _buildMobileLayout(occupancyViewModel),
                  tablet: _buildTabletLayout(occupancyViewModel),
                  desktop: _buildDesktopLayout(occupancyViewModel),
                ),
                OccupancyIndicator(
                  percentage: occupancyViewModel.occupancyPercentage,
                  occupied: occupancyViewModel.occupiedKennels,
                  total: occupancyViewModel.totalKennels,
                  cleaning: occupancyViewModel.cleaningKennels,
                  maintenance: occupancyViewModel.maintenanceKennels,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _showAddStayDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: const Color(0xFF00FFF5),
                    side: const BorderSide(color: Color(0xFF00FFF5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 8),
                      Text('Añadir estancia'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(OccupancyViewModel occupancyViewModel) {
    return Column(
      children: [
        _buildHallwayExpansionTile('Pasillo 1', occupancyViewModel.hallway1Occupancy, 1, 5, occupancyViewModel),
        _buildHallwayExpansionTile('Pasillo 2', occupancyViewModel.hallway2Occupancy, 51, 5, occupancyViewModel),
        _buildHallwayExpansionTile('Pasillo 3', occupancyViewModel.hallway3Occupancy, 101, 5, occupancyViewModel),
      ],
    );
  }

  Widget _buildTabletLayout(OccupancyViewModel occupancyViewModel) {
    return Column(
      children: [
        _buildHallwayExpansionTile('Pasillo 1', occupancyViewModel.hallway1Occupancy, 1, 7, occupancyViewModel),
        _buildHallwayExpansionTile('Pasillo 2', occupancyViewModel.hallway2Occupancy, 51, 7, occupancyViewModel),
        _buildHallwayExpansionTile('Pasillo 3', occupancyViewModel.hallway3Occupancy, 101, 7, occupancyViewModel),
      ],
    );
  }

  Widget _buildDesktopLayout(OccupancyViewModel occupancyViewModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: KennelGrid(
            occupiedKennels: occupancyViewModel.hallway1Occupancy,
            hallwayName: 'Pasillo Nº 01',
            startNumber: 1,
            columns: 10,
            onKennelTap: (index) => occupancyViewModel.toggleKennelOccupancy(1, index),
          ),
        ),
        Expanded(
          child: KennelGrid(
            occupiedKennels: occupancyViewModel.hallway2Occupancy,
            hallwayName: 'Pasillo Nº 02',
            startNumber: 51,
            columns: 10,
            onKennelTap: (index) => occupancyViewModel.toggleKennelOccupancy(2, index),
          ),
        ),
        Expanded(
          child: KennelGrid(
            occupiedKennels: occupancyViewModel.hallway3Occupancy,
            hallwayName: 'Pasillo Nº 03',
            startNumber: 101,
            columns: 10,
            onKennelTap: (index) => occupancyViewModel.toggleKennelOccupancy(3, index),
          ),
        ),
      ],
    );
  }

  Widget _buildHallwayExpansionTile(String title, List<bool> occupancy, int startNumber, int columns, OccupancyViewModel viewModel) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF202020),
      collapsedBackgroundColor: const Color(0xFF202020),
      children: [
        KennelGrid(
          occupiedKennels: occupancy,
          hallwayName: 'Pasillo Nº ${(startNumber ~/ 50) + 1}',
          startNumber: startNumber,
          columns: columns,
          onKennelTap: (index) => viewModel.toggleKennelOccupancy((startNumber ~/ 50) + 1, index),
        ),
      ],
    );
  }

  void _showAddStayDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final occupancyViewModel = Provider.of<OccupancyViewModel>(context);
          final pets = occupancyViewModel.pets;

          if (pets.isEmpty) {
            return AlertDialog(
              title: const Text('No hay mascotas', style: TextStyle(color: Colors.white)),
              backgroundColor: const Color(0xFF202020),
              content: const Text('No hay mascotas registradas. Por favor, añade una mascota primero.', style: TextStyle(color: Colors.white)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK', style: TextStyle(color: Color(0xFF00FFF5))),
                ),
              ],
            );
          }

          return AlertDialog(
            title: const Text('Añadir nueva estancia',
              style: TextStyle(color: Colors.white)),
            backgroundColor: const Color(0xFF202020),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<Pet>(
                    value: _selectedPet,
                    hint: const Text('Seleccionar mascota',
                      style: TextStyle(color: Colors.white70)),
                    items: Provider.of<OccupancyViewModel>(context).pets.map((Pet pet) {
                      return DropdownMenuItem<Pet>(
                        value: pet,
                        child: Text(pet.name,
                          style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (Pet? newValue) {
                      setState(() {
                        _selectedPet = newValue;
                      });
                    },
                    dropdownColor: const Color(0xFF202020),
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                    underline: Container(
                      height: 2,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TableCalendar(
                    firstDay: DateTime.now(),
                    lastDay: DateTime.now().add(const Duration(days: 365)),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) =>
                        isSameDay(_rangeStart, day) || isSameDay(_rangeEnd, day),
                    rangeStartDay: _rangeStart,
                    rangeEndDay: _rangeEnd,
                    calendarFormat: CalendarFormat.month,
                    rangeSelectionMode: RangeSelectionMode.enforced,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    onRangeSelected: (start, end, focusedDay) {
                      setState(() {
                        _rangeStart = start;
                        _rangeEnd = end;
                        _focusedDay = focusedDay;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    calendarStyle: CalendarStyle(
                      defaultTextStyle: const TextStyle(color: Colors.white),
                      weekendTextStyle: const TextStyle(color: Colors.white70),
                      holidayTextStyle: const TextStyle(color: Colors.white),
                      selectedTextStyle: const TextStyle(color: Colors.black),
                      todayTextStyle: const TextStyle(color: Colors.black),
                      outsideTextStyle: const TextStyle(color: Colors.white54),
                      rangeStartTextStyle: const TextStyle(color: Colors.black),
                      rangeEndTextStyle: const TextStyle(color: Colors.black),
                      disabledTextStyle: const TextStyle(color: Colors.grey),
                      selectedDecoration: const BoxDecoration(
                        color: Color(0xFF00FFF5),
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: const BoxDecoration(
                        color: Color(0xFFFFE605),
                        shape: BoxShape.circle,
                      ),
                      rangeStartDecoration: const BoxDecoration(
                        color: Color(0xFF00FFF5),
                        shape: BoxShape.circle,
                      ),
                      rangeEndDecoration: const BoxDecoration(
                        color: Color(0xFF00FFF5),
                        shape: BoxShape.circle,
                      ),
                      rangeHighlightColor: const Color(0xFF00FFF5).withOpacity(0.2),
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
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar',
                  style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: _saveStay,
                child: const Text('Guardar',
                  style: TextStyle(color: Color(0xFF00FFF5))),
              ),
            ],
          );
        },
      ),
    );
  }

  void _saveStay() async {
    if (_selectedPet != null && _rangeStart != null && _rangeEnd != null) {
      final stay = Stay(
        petId: _selectedPet!.id,
        startDate: _rangeStart!,
        endDate: _rangeEnd!,
      );
      await DatabaseHelper.instance.insertStay(stay);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Estancia guardada correctamente')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, seleccione una mascota y un rango de fechas')),
      );
    }
  }
}

