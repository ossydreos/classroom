// lib/screens/room_list_screen.dart
import 'package:flutter/material.dart';

import './chat_screen.dart';

class RoomListScreen extends StatelessWidget {
  final List<String> rooms = [
    'General',
    'Technology',
    'Sports',
    'Music',
    // Add more rooms as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Room'),
      ),
      body: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (ctx, index) {
          return ListTile(
            title: Text(rooms[index]),
            onTap: () {
              // Navigate to chat screen specific to the room
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ChatScreen(roomName: rooms[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}