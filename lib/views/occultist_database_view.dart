import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/occult_item_model.dart';

class OccultistDatabaseView extends StatelessWidget {
  const OccultistDatabaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("OCCULT LIBRARY"),
          bottom: const TabBar(
            tabs: [Tab(text: "ITEMS"), Tab(text: "RITUALS"), Tab(text: "ENTITIES")],
            indicatorColor: Colors.purpleAccent,
          ),
        ),
        body: TabBarView(
          children: [
            _buildList("ITEM"),
            _buildList("RITUAL"),
            _buildList("ENTITY"),
          ],
        ),
      ),
    );
  }

  Widget _buildList(String category) {
    return StreamBuilder<List<OccultItemModel>>(
      stream: FirestoreService().getOccultItems(category),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        if (snapshot.data!.isEmpty) return const Center(child: Text("NO ENTRIES FOUND", style: TextStyle(color: Colors.grey)));

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16, mainAxisSpacing: 16
          ),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final item = snapshot.data![index];
            return Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.withOpacity(0.5)), color: const Color(0xFF0D1117)),
              child: Column(
                children: [
                  Expanded(child: item.imageUrl.isNotEmpty ? Image.network(item.imageUrl, fit: BoxFit.cover) : const Icon(Icons.book, size: 50, color: Colors.grey)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text("DANGER: ${item.dangerLevel}", style: const TextStyle(color: Colors.redAccent, fontSize: 10)),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}