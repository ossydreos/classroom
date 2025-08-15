import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({super.key});

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  var _enteredMessage;

  void _sendMessage(){
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance.collection('chat').add({
      'text' : _enteredMessage
    });


  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration: InputDecoration(labelText: 'Envoyer un message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(color: Theme.of(context).primaryColor,
          icon: Icon(Icons.send),
          onPressed: _enteredMessage.trim().isEmpty ? null : () {
            
          },)
        ],
      ),
    );
  }
}
