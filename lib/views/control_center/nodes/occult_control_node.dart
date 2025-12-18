import 'package:flutter/material.dart';
import '../../../models/occult_item_model.dart';
import '../../../services/firestore_service.dart';

class OccultControlNode extends StatefulWidget {
  const OccultControlNode({super.key});
  @override
  State<OccultControlNode> createState() => _OccultControlNodeState();
}

class _OccultControlNodeState extends State<OccultControlNode> {
  final FirestoreService _db = FirestoreService();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _imgCtrl = TextEditingController();
  String _category = 'ITEM';
  String _danger = 'LOW';

  void _showEditor(BuildContext context, {OccultItemModel? item}) {
    // ... (Similar Init Logic as others)
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF0D1117),
      title: const Text("LIBRARY ENTRY", style: TextStyle(color: Colors.tealAccent)),
      content: SingleChildScrollView(
        child: Column(children: [
          TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: "NAME")),
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: _category,
            dropdownColor: const Color(0xFF0D1117),
            isExpanded: true,
            items: ['ITEM', 'RITUAL', 'ENTITY'].map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(color: Colors.white)))).toList(),
            onChanged: (v) => setState(() { _category = v!; Navigator.pop(ctx); _showEditor(context, item: item); }),
          ),
          const SizedBox(height: 10),
          TextField(controller: _descCtrl, maxLines: 3, decoration: const InputDecoration(labelText: "DESCRIPTION")),
           const SizedBox(height: 10),
          TextField(controller: _imgCtrl, decoration: const InputDecoration(labelText: "IMAGE URL")),
        ]),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            _db.saveOccultItem(OccultItemModel(
              id: item?.id,
              name: _nameCtrl.text,
              category: _category,
              dangerLevel: _danger,
              description: _descCtrl.text,
              containment: "Standard Protocols",
              imageUrl: _imgCtrl.text,
            ));
            Navigator.pop(ctx);
          },
          child: const Text("CATALOG ENTRY"),
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("OCCULTISM CONTROL")),
      floatingActionButton: FloatingActionButton(child: const Icon(Icons.add), onPressed: () => _showEditor(context)),
      body: StreamBuilder<List<OccultItemModel>>(
        stream: _db.getOccultItems('ITEM'), // Simple view for now, fetches ITEMs
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snap.data!.length,
            itemBuilder: (c, i) => ListTile(
              title: Text(snap.data![i].name, style: const TextStyle(color: Colors.white)),
              trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _db.deleteOccultItem(snap.data![i].id!)),
              onTap: () => _showEditor(context, item: snap.data![i]),
            ),
          );
        },
      ),
    );
  }
}