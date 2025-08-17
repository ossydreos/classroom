// lib/screens/room_list_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/rooms/room_card.dart';

import '../widgets/auth/log_out.dart';

class RoomListScreen extends StatelessWidget {
  const RoomListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Room'),
        actions: [
          LogOut(),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('rooms').snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Erreur Firestore'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Aucune room trouvée'));
          }

          final rooms = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: rooms.length,
            itemBuilder: (ctx, index) {
              final doc = rooms[index];
              final roomId = doc.id;
              final data = doc.data();
              final roomName = data['name'] ?? '(sans nom)';

              return RoomCard(roomName: roomName, roomId: roomId);
            },
          );
        },
      ),
    );
  }
}
