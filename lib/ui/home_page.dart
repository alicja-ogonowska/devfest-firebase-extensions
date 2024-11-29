import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fir_extensions_demo/model/content.dart';
import 'package:fir_extensions_demo/model/transcription.dart';
import 'package:fir_extensions_demo/ui/add_content_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text('Saved contents'),
              actions: [
                TextButton(
                  onPressed: () async {
                    final auth = FirebaseAuth.instance;
                    if (auth.currentUser != null) {
                      await auth.signOut();
                    } else {
                      await auth.signInAnonymously();
                    }
                  },
                  child: Text(userSnapshot.data != null ? 'Log out' : 'Log in'),
                ),
              ],
            ),
            body: userSnapshot.data != null
                ? StreamBuilder<QuerySnapshot>(
                    stream: contentsQuery(userSnapshot.data!.uid).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.data == null) {
                        return const Center(
                            child: Text('Oops, something went wrong...'));
                      }
                      if (snapshot.data!.size == 0) {
                        return const Center(child: Text('No data yet'));
                      }
                      return _ContentList(data: snapshot.data!);
                    },
                  )
                : const Center(child: Text('Authenticate first')),
            floatingActionButton: userSnapshot.data != null
                ? FloatingActionButton(
                    onPressed: () {
                      _openAddContentPage(userSnapshot.data?.uid);
                    },
                    tooltip: 'Add new content',
                    child: const Icon(Icons.add),
                  )
                : null,
          );
        });
  }

  void _openAddContentPage(String? userId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddContentPage(),
      ),
    );
  }
}

class _ContentList extends StatelessWidget {
  const _ContentList({required this.data});

  final QuerySnapshot<Object?> data;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.size,
      itemBuilder: (BuildContext context, int idx) {
        final content = Content.fromFirestore(
          data.docs[idx] as DocumentSnapshot<Map<String, dynamic>>,
        );
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.network(
                content.imageUrl!,
                width: MediaQuery.of(context).size.width / 2,
                errorBuilder: (_, __, ___) => Placeholder(
                  fallbackWidth: MediaQuery.of(context).size.width / 2,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _TranscriptionInfo(content: content),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TranscriptionInfo extends StatelessWidget {
  const _TranscriptionInfo({
    required this.content,
  });

  final Content content;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: transcriptionQuery(content.recordingUrl!).snapshots(),
        builder: (context, snapshot) {
          const noTranscriptionText = Text(
            'No transcription available',
            textAlign: TextAlign.start,
          );

          if (snapshot.hasData && snapshot.data!.size > 0) {
            final transcription = Transcription.fromFirestore(
              snapshot.data!.docs.first
                  as DocumentSnapshot<Map<String, dynamic>>,
            );
            return transcription.value != null
                ? Text(
                    transcription.value!,
                    textAlign: TextAlign.start,
                  )
                : noTranscriptionText;
          }
          return noTranscriptionText;
        });
  }
}
