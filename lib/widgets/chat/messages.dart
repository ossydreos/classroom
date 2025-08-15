import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chat').snapshots(),
      builder: (context, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (chatSnapshot.hasError) {
          return Center(child: Text('An error occurred!'));
        }
        final chatDocs = chatSnapshot.data?.docs ?? [];
        return ListView.builder(
          itemCount: chatDocs.length,
          itemBuilder: (context, index) => Text('${chatDocs[index]['text']}')
          );

      }
    );
  }
}