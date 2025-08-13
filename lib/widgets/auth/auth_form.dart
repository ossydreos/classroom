import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  
  final _formKey = GlobalKey<FormState>();
  String? _userEmail = '';
  String? _userName = '';
  String? _userPassword = '';

  void _trySubmit(){
    final form = _formKey.currentState;
    if( form != null){
      final isValid = form.validate();
      if (!isValid) {
        return;
    }
    form.save();
    }
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    validator: (value) {
                      if(value == null || value.isEmpty || !value.contains('@')) {
                        return 'Veuillez entrer une adresse email valide';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Adresse email'),
                    onSaved: (newValue) {
                      _userEmail = newValue;
                    },
                  ),
                  TextFormField(
                    validator: (value) {
                      if(value == null || value.isEmpty || value.length<4) {
                        return "Le nom d'utilisateur doit faire au moins 4 caractères";
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Nom d'utilisateur"),
                    onSaved: (newValue) {
                      _userName = newValue;
                    },
                  ),
                  TextFormField(
                    validator: (value) {
                      if(value == null || value.isEmpty || value.length<7) {
                        return 'Votre mot de passe doit faire au moins 7 caractères';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Mot de passe'),
                    obscureText: true,
                    onSaved: (newValue) {
                      _userPassword = newValue;
                    },
                    
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(child: Text('Connexion'), onPressed: () {}),
                  TextButton(
                    child: Text('Nouvel utilisateur'),
                    onPressed: () {
                    
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
