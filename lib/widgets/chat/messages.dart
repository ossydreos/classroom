import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './message_bubble.dart';

class Messages extends StatelessWidget {
  final String roomName;
  const Messages({super.key, required this.roomName});

  @override
  Widget build(BuildContext context) {
    final roomsRef = FirebaseFirestore.instance.collection('rooms');

    return FutureBuilder<QuerySnapshot>(
      future: roomsRef.where('name', isEqualTo: roomName).get(),
      builder: (context, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        if (snap.data!.docs.isEmpty) return const Center(child: Text('Room introuvable'));

        final roomId = snap.data!.docs.first.id;

        return StreamBuilder<QuerySnapshot>(
          stream: roomsRef.doc(roomId).collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, chatSnap) {
            if (!chatSnap.hasData) return const Center(child: CircularProgressIndicator());
            final docs = chatSnap.data!.docs;
            return ListView.builder(
              reverse: true,
              itemCount: docs.length,
              itemBuilder: (c, i) {
                final m = docs[i].data() as Map<String, dynamic>;
                return MessageBubble(
                  m['text'],
                  m['username'],
                  m['userImage'],
                  m['userId'] == FirebaseAuth.instance.currentUser?.uid,
                  key: ValueKey(docs[i].id),
                );
              },
            );
          },
        );
      },
    );
  }
}
