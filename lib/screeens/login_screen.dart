import 'package:flutter/material.dart';

/// This class represents a login screen in a Flutter application.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final conUser = TextEditingController();
  final conPwd = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    TextFormField txtUser = TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
          prefixIcon: Icon(
        Icons.person,
      )),
      controller: conUser,
    );
    TextFormField txtPwd = TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: conPwd,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.password,
        ),
      ),
      obscureText: true,
    );

    final ctnCredentials = Positioned(
      bottom: 170,
      child: Container(
        width: MediaQuery.of(context).size.width * .9,
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView(
          shrinkWrap: true,
          children: [txtUser, txtPwd],
        ),
      ),
    );

    final btnLogin = Positioned(
      width: MediaQuery.of(context).size.width * .5,
      height: 50,
      bottom: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 0, 178, 202),
        ),
        onPressed: () {
          isLoading = true;
          setState(() {});
          Future.delayed(
            const Duration(milliseconds: 4000),
          ).then((response) => {
                isLoading = false,
                setState(() {}),
                Navigator.pushNamed(context, "/home")
              });
        },
        child: const Text('Iniciar Sesión'),
      ),
    );

    final btnRegistrarse = Positioned(
      width: MediaQuery.of(context).size.width * .5,
      height: 50,
      bottom: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(0, 0, 178, 202),
        ),
        onPressed: () {
          isLoading = true;
          setState(() {});
          Future.delayed(
            const Duration(milliseconds: 4000),
          ).then((response) => {
                isLoading = false,
                setState(() {}),
                Navigator.pushNamed(context, "/register")
              });
        },
        child: const Text('Registrarse'),
      ),
    );

    final gifLoading = Positioned(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Color.fromARGB(141, 0, 0, 0),
        ),
        child: Image.asset('assets/loading.gif'),
      ),
    );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/back.webp"),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 50,
              child: Image.asset(
                'assets/logo.png',
                width: 300,
              ),
            ),
            ctnCredentials,
            btnLogin,
            btnRegistrarse,
            isLoading ? gifLoading : Container()
          ],
        ),
      ),
    );
  }
}
