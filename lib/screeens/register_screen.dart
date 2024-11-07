import 'package:flutter/material.dart';

/// This class represents a login screen in a Flutter application.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final conUser = TextEditingController();
  final conPwd = TextEditingController();
  final conMail = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextFormField txtUser = TextFormField(
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          prefixIcon: Icon(
        Icons.person,
      )),
      controller: conUser,
    );

    TextFormField txtMail = TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
          prefixIcon: Icon(
        Icons.mail,
      )),
      controller: conMail,
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
          children: [txtMail, txtUser, txtPwd],
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
        onPressed: () async {
          // isLoading = true;
          // auth.createUser(conUser.text, conMail.text, conPwd.text).then(
          //   (value) {
          //     value
          //         ? setState(() {
          //             isLoading = false;
          //             print('USUARIO REGISTRADO');
          //           })
          //         : isLoading;
          //   },
          // );
        },
        child: const Text('Registrar'),
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
            isLoading ? gifLoading : Container()
          ],
        ),
      ),
    );
  }
}
