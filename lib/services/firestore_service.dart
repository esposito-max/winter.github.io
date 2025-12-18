import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mission_model.dart';
import '../models/agent_model.dart';
import '../models/report_model.dart';
import '../models/occult_item_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- MISSIONS ---
  Stream<List<MissionModel>> getMissions() => _db.collection('active_missions')
      .snapshots().map((s) => s.docs.map((d) => MissionModel.fromMap(d.data(), d.id)).toList());
  Future<void> saveMission(MissionModel m) async => m.id == null 
      ? await _db.collection('active_missions').add(m.toMap()) 
      : await _db.collection('active_missions').doc(m.id).update(m.toMap());
  Future<void> deleteMission(String id) async => await _db.collection('active_missions').doc(id).delete();

  // --- AGENTS ---
  Stream<List<AgentModel>> getAgents() => _db.collection('agents')
      .orderBy('division').snapshots().map((s) => s.docs.map((d) => AgentModel.fromMap(d.data(), d.id)).toList());
  Future<void> saveAgent(AgentModel a) async => a.id == null 
      ? await _db.collection('agents').add(a.toMap()) 
      : await _db.collection('agents').doc(a.id).update(a.toMap());
  Future<void> deleteAgent(String id) async => await _db.collection('agents').doc(id).delete();

  // --- REPORTS ---
  Stream<List<ReportModel>> getReports() => _db.collection('reports')
      .orderBy('date', descending: true).snapshots().map((s) => s.docs.map((d) => ReportModel.fromMap(d.data(), d.id)).toList());
  Future<void> saveReport(ReportModel r) async => r.id == null 
      ? await _db.collection('reports').add(r.toMap()) 
      : await _db.collection('reports').doc(r.id).update(r.toMap());
  Future<void> deleteReport(String id) async => await _db.collection('reports').doc(id).delete();

  // --- OCCULT LIBRARY ---
  Stream<List<OccultItemModel>> getOccultItems(String category) => _db.collection('occult_library')
      .where('category', isEqualTo: category).snapshots().map((s) => s.docs.map((d) => OccultItemModel.fromMap(d.data(), d.id)).toList());
  Future<void> saveOccultItem(OccultItemModel item) async => item.id == null 
      ? await _db.collection('occult_library').add(item.toMap()) 
      : await _db.collection('occult_library').doc(item.id).update(item.toMap());
  Future<void> deleteOccultItem(String id) async => await _db.collection('occult_library').doc(id).delete();
}