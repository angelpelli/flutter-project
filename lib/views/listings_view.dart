import 'package:flutter/material.dart';
import 'pet_list_view.dart';
import 'owner_list_view.dart';

class ListingsView extends StatefulWidget {
  const ListingsView({Key? key}) : super(key: key);

  @override
  _ListingsViewState createState() => _ListingsViewState();
}

class _ListingsViewState extends State<ListingsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Mascotas'),
            Tab(text: 'Dueños'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              PetListView(),
              OwnerListView(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

