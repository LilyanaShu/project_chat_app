import 'dart:io';
import 'package:flutter/material.dart';

import '../user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;
  final void Function(
      String email,
      String password,
      String username,
      File? img,
      bool isLogin,
      BuildContext ctx,
      ) submitFn;

  const AuthForm({Key? key,
    required this.isLoading, required this.submitFn}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPass = '';
  File? _userImageFile;

  void _pickedImage(File image){
    _userImageFile = image;
  }

  void _trySubmit(){
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if(!_isLogin && _userImageFile == null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please pick an image"),
          backgroundColor: Colors.red,
        )
      );
    }

    if(isValid!){
      _formKey.currentState?.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPass.trim(),
        _userName.trim(),
        _userImageFile,
        _isLogin,
        context
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(!_isLogin) UserImagePicker(key: UniqueKey(), imagePickFn: _pickedImage),
                  TextFormField(
                    key: const ValueKey('email'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    validator: (value){
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                    ),
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  if(!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      validator: (value) {
                        if(value!.isEmpty || value.length <4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Username'),
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                    TextFormField(
                      key: const ValueKey('Password'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 7) {
                          return 'Password must be at least 7 characters long';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      onSaved: (value) {
                        _userPass = value!;
                      },
                    ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                        onPressed: _trySubmit,
                        child: Text(_isLogin ? 'Login' : 'SignUp')),
                  if (!widget.isLoading)
                    ElevatedButton(
                        onPressed: (){
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin ? 'Create new account' : 'I already have an account')
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
