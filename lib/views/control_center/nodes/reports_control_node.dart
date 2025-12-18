import 'package:flutter/material.dart';
import '../../../models/report_model.dart';
import '../../../services/firestore_service.dart';

class ReportsControlNode extends StatefulWidget {
  const ReportsControlNode({super.key});
  @override
  State<ReportsControlNode> createState() => _ReportsControlNodeState();
}

class _ReportsControlNodeState extends State<ReportsControlNode> {
  final FirestoreService _db = FirestoreService();
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  bool _isSensitive = false;

  void _showEditor(BuildContext context, {ReportModel? report}) {
    if (report != null) {
      _titleCtrl.text = report.title;
      _contentCtrl.text = report.content;
      _isSensitive = report.isSensitive;
    } else {
      _titleCtrl.clear(); _contentCtrl.clear();
    }

    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF0D1117),
      title: const Text("INTEL LOG", style: TextStyle(color: Colors.purpleAccent)),
      content: SingleChildScrollView(
        child: Column(children: [
          TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: "SUBJECT")),
          const SizedBox(height: 10),
          TextField(controller: _contentCtrl, maxLines: 5, decoration: const InputDecoration(labelText: "CONTENT")),
          CheckboxListTile(
            title: const Text("SENSITIVE INFO", style: TextStyle(color: Colors.white)),
            value: _isSensitive,
            onChanged: (v) => setState(() { _isSensitive = v!; Navigator.pop(ctx); _showEditor(context, report: report); }),
          )
        ]),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            _db.saveReport(ReportModel(
              id: report?.id,
              title: _titleCtrl.text,
              author: "COMMAND", // Hardcoded for simplicity
              date: DateTime.now().toString().split(' ')[0],
              content: _contentCtrl.text,
              isSensitive: _isSensitive,
              type: "MISSION",
            ));
            Navigator.pop(ctx);
          },
          child: const Text("ARCHIVE REPORT"),
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("REPORTS CONTROL")),
      floatingActionButton: FloatingActionButton(child: const Icon(Icons.add), onPressed: () => _showEditor(context)),
      body: StreamBuilder<List<ReportModel>>(
        stream: _db.getReports(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snap.data!.length,
            itemBuilder: (c, i) => ListTile(
              title: Text(snap.data![i].title, style: const TextStyle(color: Colors.white)),
              trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _db.deleteReport(snap.data![i].id!)),
              onTap: () => _showEditor(context, report: snap.data![i]),
            ),
          );
        },
      ),
    );
  }
}