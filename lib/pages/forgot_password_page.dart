import 'package:academiaapp/common/providers/snack_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:academiaapp/common/providers/container_provider.dart';


class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Recuperar senha"),
      ),
      body: ContainerProvider(
        horizontal: 10,
        vertical: 30,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                // key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Image(
                      image: AssetImage('assets/images/gym-icon.png'),
                      // width: 550,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Insira seu email',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        filled: true,
                        contentPadding:
                        EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                        labelText: "Email",
                        prefixIcon: Icon(
                          Icons.mail_outline,
                          color: Colors.blue,
                        ),
                      ),
                      validator: (String? email) {
                        if (email == null || email.isEmpty) {
                          return 'Por favor, insira seu email corretamente';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: FractionallySizedBox(
                        widthFactor: 1, // means 100%, you can change this to 0.8 (80%)
                        child: ElevatedButton(
                          child: const Text("Recuperar senha"),
                          onPressed: () {
                            if (_emailController.text.isNotEmpty && _emailController.text != ""){
                              FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBarProvider().showMessage("Foi enviado um email para recuperar sua senha!"));
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBarProvider().showMessage("Email inválido"));
                            }
                          },
                        ),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                          "Será enviado um email de recuperação de senha para o email cadastrado"
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
