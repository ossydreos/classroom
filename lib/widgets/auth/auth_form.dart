import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
 AuthForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String userName,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLogIn = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File? _userImageFile; // correction ici

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile!,
        _isLogIn,
        context,
      );
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
                  if (!_isLogIn) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'Veuillez entrer une adresse email valide';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Adresse email'),
                    onSaved: (newValue) {
                      _userEmail = newValue!;
                    },
                  ),
                  if (!_isLogIn)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 4) {
                          return "Le nom d'utilisateur doit faire au moins 4 caractères";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Nom d'utilisateur",
                      ),
                      onSaved: (newValue) {
                        _userName = newValue!;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 7) {
                        return 'Votre mot de passe doit faire au moins 7 caractères';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Mot de passe'),
                    obscureText: true,
                    onSaved: (newValue) {
                      _userPassword = newValue!;
                    },
                  ),
                  SizedBox(height: 12),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      child: Text(_isLogIn ? 'Connexion' : "S'enrengistrer"),
                      onPressed: () {
                        _trySubmit();
                      },
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      child: Text(
                        _isLogIn ? 'Nouvel utilisateur' : "J'ai déjà un compte",
                      ),
                      onPressed: () {
                        setState(() => _isLogIn = !_isLogIn);
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
