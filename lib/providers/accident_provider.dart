import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:constatel/models/accident.dart';


class AccidentProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveAccident(Accident accident) async {
    try {
      await _firestore.collection('accidents').doc(accident.id).set(accident.toJson());
      print('Accident saved successfully');
    } catch (e) {
      print('Error saving accident: $e');
    }
  }

  Future<List<Accident>> fetchAccidentsByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('accidents')
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.map((doc) {
        return Accident.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching accidents: $e');
      return [];
    }
  }
}