import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import './message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (chatSnapshot.hasError) {
          return Center(child: Text('An error occurred!'));
        }
        final chatDocs = chatSnapshot.data?.docs ?? [];
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (context, index) => MessageBubble(
            chatDocs[index]['text'] as String,
            chatDocs[index]['userId'] == FirebaseAuth.instance.currentUser?.uid,
          ),
          );

      }
    );
  }
}