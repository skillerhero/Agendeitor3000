import 'package:agendeitor3000/iniciarSesionGoogle.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './registrarse.dart'; // Importar la pantalla de inicio de sesión
import './iniciarSesion.dart'; // Importar la pantalla de registro

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi aplicación',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const InitializerWidget(),
    );
  }
}

class InitializerWidget extends StatefulWidget {
  const InitializerWidget({super.key});

  @override
  _InitializerWidgetState createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp().then((value) {
        print("Firebase initialized successfully.");
      });
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return const SomethingWentWrong();
    }
    if (!_initialized) {
      return Loading();
    }
    return const HomePage();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Asumiendo que ya tienes un método para iniciar sesión
  void signIn() async {
    // Tu lógica de inicio de sesión aquí...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendeitor 3000'),
      ),

      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 44, 46, 51), // Cambia esto a tu color de fondo
          image: DecorationImage(
            image: AssetImage("assets/logo.png"),
            fit: BoxFit.none, 
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => IniciarSesion()),
                    );
                  // Lógica cuando se presiona el primer botón
                  print('Se presionó el primer botón');
                },
                child: Text('Iniciar Sesión'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Registrarse()),
                    );
                  // Lógica cuando se presiona el segundo botón
                  print('Se presionó el segundo botón');
                },
                child: Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Algo salió mal')),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
