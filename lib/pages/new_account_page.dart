import 'package:academiaapp/common/providers/snack_bar_provider.dart';
import 'package:flutter/material.dart';

/*Providers*/
import 'package:academiaapp/common/providers/container_provider.dart';
import 'package:academiaapp/common/providers/firebase_auth_provider.dart';

class NewAccountPage extends StatefulWidget {
  const NewAccountPage({Key? key}) : super(key: key);

  @override
  _NewAccountPageState createState() => _NewAccountPageState();
}

class _NewAccountPageState extends State<NewAccountPage> {
  final TextEditingController _nameInputController = TextEditingController();
  final TextEditingController _emailInputController = TextEditingController();
  final TextEditingController _passwordInputController = TextEditingController();
  TextEditingController _confirmInputController = TextEditingController();
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();


  void _doSignUp() {
    if (_formKey.currentState!.validate()) {
      SignUpProvider()
          .signUp(
          _emailInputController.text,
          _passwordInputController.text,
          _nameInputController.text
      );
    } else {
      SnackBarProvider().showWrongSignUp();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Criar nova conta"),
      ),
      body: ContainerProvider(
        horizontal: 10,
        vertical: 30,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Image(
                      image: AssetImage('assets/images/gym-icon.png'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _nameInputController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Insira seu nome',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.blue)
                        ),
                        filled: true,
                        contentPadding:
                        EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                        labelText: "Nome",
                        prefixIcon: Icon(
                          Icons.text_fields_sharp,
                          color: Colors.blue,
                        ),
                      ),
                      validator: (String? email) {
                        if (email == null || email.isEmpty) {
                          return 'Por favor, insira seu nome corretamente';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailInputController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Insira seu email',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.blue)
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
                        } else if (!email.contains("@")) {
                          return "E-mail inválido";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: _obscurePassword,
                      controller: _passwordInputController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off: Icons.visibility,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        hintText: 'Insira seu senha',
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.blue)
                        ),
                        filled: true,
                        contentPadding:
                        const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                        labelText: "Senha",
                        prefixIcon: const Icon(
                          Icons.vpn_key_sharp,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: FractionallySizedBox(
                        widthFactor: 1, // means 100%, you can change this to 0.8 (80%)
                        child: ElevatedButton(
                          child: const Text("Criar nova conta"),
                          onPressed: () {
                            _doSignUp();
                          },
                        ),
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
