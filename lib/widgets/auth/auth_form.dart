import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
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
                  ),
                  TextFormField(
                    validator: (value) {
                      if(value == null || value.isEmpty || value.length<4) {
                        return "Le nom d'utilisateur doit faire au moins 4 caractères";
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Nom d'utilisateur"),
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
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(child: Text('Connexion'), onPressed: () {}),
                  TextButton(
                    child: Text('Nouvel utilisateur'),
                    onPressed: () {},
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
