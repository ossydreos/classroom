import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/rooms/room_card.dart';
import '../widgets/auth/log_out.dart';

class RoomListScreen extends StatelessWidget {
  const RoomListScreen({super.key});

  Stream<bool> _adminStream(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snap) => (snap.data()?['isAdmin'] ?? false) as bool);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélectionner une room'),
        actions: [LogOut()],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('rooms')
            .orderBy('createdAt', descending: false)
            .snapshots(),
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

              return RoomCard(
                roomName: roomName,
                roomId: roomId,
                isAdminStream: user != null
                    ? _adminStream(user.uid)
                    : const Stream.empty(),
                scaffoldContext: context,
              );
            },
          );
        },
      ),
      floatingActionButton: user == null
          ? null
          : StreamBuilder<bool>(
              stream: _adminStream(user.uid),
              builder: (context, snap) {
                final isAdmin = snap.data == true;
                if (!isAdmin) return const SizedBox.shrink();
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton(
                    onPressed: () => _showCreateRoomDialog(context),
                    child: const Icon(Icons.add),
                  ),
                );
              },
            ),
    );
  }

  void _showCreateRoomDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nouvelle room'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(hintText: 'Nom de la room'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = ctrl.text.trim();
              if (name.isEmpty) return;
              await FirebaseFirestore.instance.collection('rooms').add({
                'name': name,
                'createdAt': FieldValue.serverTimestamp(),
              });
              Navigator.pop(context);
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }
}
