import 'package:cloud_firestore/cloud_firestore.dart';

class Content {
  final String? imageUrl;
  final String? recordingUrl;
  final Timestamp? timestamp;

  Content({
    required this.imageUrl,
    required this.recordingUrl,
    this.timestamp,
  });

  factory Content.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Content(
      imageUrl: data?['imageUrl'],
      recordingUrl: data?['recordingUrl'],
      timestamp: data?['timestamp'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'imageUrl': imageUrl,
      'recordingUrl': recordingUrl,
      'timestamp': timestamp ?? Timestamp.now(),
    };
  }
}

Query contentsQuery(String userId) => FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .collection('contents')
    .orderBy('timestamp', descending: true);
