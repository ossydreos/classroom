import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/chat/messages.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
        actions: [
          DropdownButton(
            icon: Icon(Icons.more_vert, color: Colors.white,),
            items: [
              DropdownMenuItem(
                value: 'logout',
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app, color: Colors.black,),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
              ),
            ],
            onChanged: (itemIdentifier) {
              if(itemIdentifier == 'logout'){
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: Container(
        child: Column(children: <Widget>[Expanded(child: Messages())]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/klSHI7dxjkq4Lakm5Rk8/messages')
              .add({'text': 'Ajouté avec le bouton'});
        },
      ),
    );
  }
}
