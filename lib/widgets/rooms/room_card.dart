import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../screens/chat_screen.dart';

class RoomCard extends StatelessWidget {
  final String roomName;
  final String roomId;
  final Stream<bool> isAdminStream;
  final BuildContext scaffoldContext;

  const RoomCard({
    super.key,
    required this.roomName,
    required this.roomId,
    required this.isAdminStream,
    required this.scaffoldContext,
  });

void _confirmDeleteRoom(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Supprimer la room ?'),
        content: Text('“$roomName” et tous ses messages seront supprimés.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogCtx).pop(), child: const Text('Annuler')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.of(dialogCtx).pop();
              await _deleteRoomCascade(roomId);
              ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                SnackBar(content: Text('Room "$roomName" supprimée')),
              );
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteRoomCascade(String roomId) async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    while (true) {
      final batch = FirebaseFirestore.instance.batch();
      final snap = await roomRef.collection('chat').limit(300).get();
      if (snap.docs.isEmpty) break;
      for (final d in snap.docs) {
        batch.delete(d.reference);
      }
      await batch.commit();
    }
    await roomRef.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            roomName.isNotEmpty ? roomName[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(roomName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        trailing: StreamBuilder<bool>(
          stream: isAdminStream,
          builder: (context, snap) {
            final isAdmin = snap.data == true;
            if (isAdmin) {
              return IconButton(
                icon: const Icon(Icons.delete, color: Colors.blueGrey),
                onPressed: () => _confirmDeleteRoom(context),
              );
            }
            return const Icon(Icons.arrow_forward_ios, size: 16);
          },
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => ChatScreen(roomId: roomId)),
          );
        },
      ),
    );
  }

  
}
