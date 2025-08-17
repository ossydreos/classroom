// lib/screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/auth/log_out.dart';
import '../widgets/chat/message_bubble.dart';
import '../widgets/chat/new_message.dart';

class ChatScreen extends StatelessWidget {
  final String roomId;

  const ChatScreen({required this.roomId});

  @override
  Widget build(BuildContext context) {
    final roomsRef = FirebaseFirestore.instance.collection('rooms');

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: roomsRef.doc(roomId).snapshots(),
          builder: (ctx, snapshot) {
            if (!snapshot.hasData) return const Text('...');
            final data = snapshot.data!.data();
            final roomName = data?['name'] ?? 'Room';
            return Text(roomName);
          },
        ),
        actions: [
          LogOut(),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: roomsRef
                  .doc(roomId)
                  .collection('chat')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Erreur Firestore'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Aucun message'));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (ctx, i) {
                    final msg = messages[i].data();
                    final isMe = msg['userId'] ==
                        FirebaseAuth.instance.currentUser?.uid;

                    return MessageBubble(
                      msg['text'] ?? '',
                      msg['username'] ?? 'Anonyme',
                      msg['userImage'] ?? '',
                      isMe,
                      key: ValueKey(messages[i].id),
                    );
                  },
                );
              },
            ),
          ),
          // Zone de saisie
          NewMessage(roomId: roomId),
        ],
      ),
    );
  }
}
