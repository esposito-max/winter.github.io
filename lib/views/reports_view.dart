import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/report_model.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("INTEL ARCHIVE")),
      body: StreamBuilder<List<ReportModel>>(
        stream: FirestoreService().getReports(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            separatorBuilder: (_, __) => const Divider(color: Colors.grey),
            itemBuilder: (context, index) {
              final report = snapshot.data![index];
              return ListTile(
                title: Text(report.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text("${report.date} | AUTHOR: ${report.author}", style: const TextStyle(color: Colors.grey, fontSize: 10)),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: const Color(0xFF0A0E14),
                    builder: (ctx) => Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(report.content, style: const TextStyle(color: Colors.white70, fontFamily: 'monospace')),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}