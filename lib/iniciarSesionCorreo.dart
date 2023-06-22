// ignore_for_file: file_names

import 'package:flutter/material.dart';

class IniciarSesionCorreo extends StatelessWidget {
  const IniciarSesionCorreo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Iniciar sesión"), centerTitle: true),
      body: Center(
          child: Column(
        children: const [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'User Name', hintText: 'Enter valid mail id as abc@gmail.com'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Password', hintText: 'Enter your secure password'),
            ),
          ),
        ],
      )),
    );
  }
}
