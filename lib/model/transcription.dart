import 'package:cloud_firestore/cloud_firestore.dart';

class Transcription {
  final String? value;
  final Timestamp? timestamp;

  Transcription({
    required this.value,
    this.timestamp,
  });

  factory Transcription.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    final transcriptionData = data?['transcription'];
    return Transcription(
      value: transcriptionData?['0']?.join(''),
      timestamp: data?['created'],
    );
  }
}

Query transcriptionQuery(String filePath) => FirebaseFirestore.instance
    .collection('transcriptions')
    .where('fileName', isEqualTo: filePath)
    .where('status', isEqualTo: 'SUCCESS')
    .limit(1);
