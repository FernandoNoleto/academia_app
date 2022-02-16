import 'package:flutter/material.dart';

/*Pages*/
import 'package:academiaapp/pages/new_account_page.dart';
import 'package:academiaapp/pages/forgot_password_page.dart';

/*Providers*/
import 'package:academiaapp/common/providers/container_provider.dart';
import 'package:academiaapp/common/providers/firebase_auth_provider.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _mailInputController = TextEditingController();
  TextEditingController _passwordInputController = TextEditingController();
  bool _obscurePassword = true;


  /*Functions*/

  void _doLogin() async {
    if (_formKey.currentState!.validate()) {
      LoginService().login(_mailInputController.text, _passwordInputController.text);
    } else {
      print("invalido");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Login"),
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
                      // width: 550,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _mailInputController,
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
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: _obscurePassword,
                      controller: _passwordInputController,
                      // style: const TextStyle(color: Colors.white),
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
                          child: const Text("Entrar"),
                          onPressed: () {
                            _doLogin();
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.transparent),
                          primary: Colors.blue,
                          minimumSize: const Size(88, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                          );
                        },
                        child: const Text("Esqueceu sua senha?"),
                      ),
                    ),
                    // const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: FractionallySizedBox(
                        widthFactor: 1, // means 100%, you can change this to 0.8 (80%)
                        child: ElevatedButton(
                          child: const Text("Criar nova conta"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const NewAccountPage()),
                            );
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


