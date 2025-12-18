import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/agent_model.dart';

class AgentsRegistryView extends StatelessWidget {
  const AgentsRegistryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PERSONNEL DATABASE")),
      body: StreamBuilder<List<AgentModel>>(
        stream: FirestoreService().getAgents(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final agent = snapshot.data![index];
              return Card(
                color: const Color(0xFF0D1117),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(agent.imageUrl)),
                  title: Text(agent.name, style: const TextStyle(color: Colors.white, fontFamily: 'monospace')),
                  subtitle: Text("${agent.division} | ${agent.role}", style: const TextStyle(color: Colors.cyanAccent, fontSize: 10)),
                  trailing: Text(agent.status, style: const TextStyle(color: Colors.greenAccent, fontSize: 10)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}