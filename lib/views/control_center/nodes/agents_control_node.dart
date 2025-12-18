import 'package:flutter/material.dart';
import '../../../models/agent_model.dart';
import '../../../services/firestore_service.dart';

class AgentsControlNode extends StatefulWidget {
  const AgentsControlNode({super.key});
  @override
  State<AgentsControlNode> createState() => _AgentsControlNodeState();
}

class _AgentsControlNodeState extends State<AgentsControlNode> {
  final FirestoreService _db = FirestoreService();
  final _nameCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final _imgCtrl = TextEditingController();
  String _division = 'COMBAT';
  String _status = 'ACTIVE';

  void _showEditor(BuildContext context, {AgentModel? agent}) {
    if (agent != null) {
      _nameCtrl.text = agent.name;
      _roleCtrl.text = agent.role;
      _imgCtrl.text = agent.imageUrl;
      _division = agent.division;
      _status = agent.status;
    } else {
      _nameCtrl.clear(); _roleCtrl.clear(); _imgCtrl.clear();
    }

    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF0D1117),
      title: const Text("PERSONNEL RECORD", style: TextStyle(color: Colors.blueAccent)),
      content: SingleChildScrollView(
        child: Column(children: [
          TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: "NAME")),
          const SizedBox(height: 10),
          TextField(controller: _roleCtrl, decoration: const InputDecoration(labelText: "ROLE")),
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: _division,
            dropdownColor: const Color(0xFF0D1117),
            isExpanded: true,
            items: ['COMMAND', 'RESEARCH', 'COMBAT', 'INFILTRATION', 'OCCULTISM']
                .map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(color: Colors.white)))).toList(),
            onChanged: (v) => setState(() { _division = v!; Navigator.pop(ctx); _showEditor(context, agent: agent); }),
          ),
          const SizedBox(height: 10),
          TextField(controller: _imgCtrl, decoration: const InputDecoration(labelText: "IMAGE URL")),
        ]),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            _db.saveAgent(AgentModel(
              id: agent?.id,
              name: _nameCtrl.text,
              role: _roleCtrl.text,
              division: _division,
              status: _status,
              imageUrl: _imgCtrl.text,
              clearanceLevel: 1, // Default to standard clearance
            ));
            Navigator.pop(ctx);
          },
          child: const Text("SAVE RECORD"),
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AGENTS CONTROL")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showEditor(context),
      ),
      body: StreamBuilder<List<AgentModel>>(
        stream: _db.getAgents(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snap.data!.length,
            itemBuilder: (c, i) {
              final a = snap.data![i];
              return ListTile(
                title: Text(a.name, style: const TextStyle(color: Colors.white)),
                subtitle: Text("${a.division} - ${a.role}", style: const TextStyle(color: Colors.grey)),
                trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _db.deleteAgent(a.id!)),
                onTap: () => _showEditor(context, agent: a),
              );
            },
          );
        },
      ),
    );
  }
}