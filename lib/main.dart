import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' show Platform;
import 'database/database_helper.dart';
import 'responsive_layout.dart';
import 'views/occupancy_view.dart';
import 'views/stays_view.dart';
import 'views/listings_view.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:provider/provider.dart';
import 'viewmodels/pet_view_model.dart';
import 'viewmodels/owner_view_model.dart';
import 'viewmodels/stay_view_model.dart';
import 'viewmodels/occupancy_view_model.dart';
import 'viewmodels/statistics_view_model.dart';
import 'package:window_size/window_size.dart' as window_size;
import 'widgets/calendar_button.dart';
import 'widgets/statistics_button.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  runApp(const CisterCanApp());
}

Future<void> initializeApp() async {
  await _initializePlatform();
  await _initializeDatabase();
  await _configureDesktopWindow();
}

Future<void> _initializePlatform() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}

Future<void> _initializeDatabase() async {
  try {
    await DatabaseHelper.instance.database;
    await DatabaseHelper.instance.insertTestData();
  } catch (e) {
    print("Error during database initialization: $e");
    // Consider implementing a more robust error handling strategy here
  }
}

Future<void> _configureDesktopWindow() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    window_size.setWindowTitle('CisterCan');
    window_size.setWindowMinSize(const Size(600, 400));
    window_size.setWindowMaxSize(Size.infinite);
  }
}

class CisterCanApp extends StatelessWidget {
  const CisterCanApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PetViewModel()),
        ChangeNotifierProvider(create: (_) => OwnerViewModel()),
        ChangeNotifierProvider(create: (_) => StayViewModel()),
        ChangeNotifierProvider(create: (_) => OccupancyViewModel()),
        ChangeNotifierProvider(create: (_) => StatisticsViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CisterCan',
        theme: _buildTheme(context),
        home: const HomePage(),
      ),
    );
  }

  ThemeData _buildTheme(BuildContext context) {
    return ThemeData(
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF00FFF5),
        secondary: Color(0xFFFFE605),
        surface: Color(0xFF202020),
        error: Color(0xFFFF0000),
      ),
      scaffoldBackgroundColor: const Color(0xFF111111),
      textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.white70),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(),
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
        desktop: _buildDesktopLayout(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'CisterCan',
        style: GoogleFonts.orbitron(
          textStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      actions: const [
        CalendarButton(),
        SizedBox(width: 8),
        StatisticsButton(),
        SizedBox(width: 16),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Expanded(
          child: IndexedStack(
            index: _selectedIndex,
            children: const [
              StaysView(),
              OccupancyView(),
              ListingsView(),
            ],
          ),
        ),
        _buildBottomNavigationBar(),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        _buildNavigationRail(),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: IndexedStack(
            index: _selectedIndex,
            children: const [
              StaysView(),
              OccupancyView(),
              ListingsView(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      children: [
        _buildDesktopNavBar(),
        Expanded(
          child: IndexedStack(
            index: _selectedIndex,
            children: const [
              StaysView(),
              OccupancyView(),
              ListingsView(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF111111),
        border: Border(
          top: BorderSide(
            color: Color(0xFF202020),
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFF111111),
        selectedItemColor: const Color(0xFF00FFF5),
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Estancias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Ocupación',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            activeIcon: Icon(Icons.pets),
            label: 'Listados',
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRail() {
    return NavigationRail(
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onItemTapped,
      backgroundColor: const Color(0xFF111111),
      selectedIconTheme: const IconThemeData(
        color: Color(0xFF00FFF5),
      ),
      unselectedIconTheme: const IconThemeData(
        color: Colors.white,
      ),
      labelType: NavigationRailLabelType.selected,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.calendar_today_outlined),
          selectedIcon: Icon(Icons.calendar_today),
          label: Text('Estancias'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Ocupación'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.pets),
          selectedIcon: Icon(Icons.pets),
          label: Text('Listados'),
        ),
      ],
    );
  }

  Widget _buildDesktopNavBar() {
    return Container(
      color: const Color(0xFF202020),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNavItem(0, Icons.calendar_today, 'Estancias'),
          _buildNavItem(1, Icons.home, 'Ocupación'),
          _buildNavItem(2, Icons.pets, 'Listados'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        color: _selectedIndex == index ? const Color(0xFF00FFF5) : Colors.transparent,
        child: Row(
          children: [
            Icon(
              icon,
              color: _selectedIndex == index ? const Color(0xFF111111) : Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: _selectedIndex == index ? const Color(0xFF111111) : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

