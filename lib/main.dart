import 'package:cloud_firestore/cloud_firestore.dart';
import 'classroom.dart';
import 'agregarTarea.dart';
import 'iniciarSesionGoogle.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'tareasPendientes.dart';

//usa async porque
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    runApp(
      const MaterialApp(
        title: 'Proyecto modular',
        home: TareasPendientesWidget(),
        supportedLocales: [Locale('en', ''), Locale('es', '')],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  });
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);
  @override
  State createState() => WidgetSate();
}

class WidgetSate extends State<HomeWidget> {
  String texto = '';

  @override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? cuenta) {
      setState(() {
        usuarioActual = cuenta;
        if (usuarioActual != null) {
          agregarUsuario(usuarioActual!);
        }
      });
    });
    googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Prueba de Yess'),
        ),
        body: ConstrainedBox(constraints: const BoxConstraints.expand(), child: buildBody()));
  }

  Widget buildBody() {
    final GoogleSignInAccount? user = usuarioActual;
    bool customTileExpanded = false;
    if (user != null) {
      return SingleChildScrollView(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          const Text('Inicio de sesión exitoso.'),

          //se usa streambuilder para detectar cambios en la base de datos de firebase
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection("usuarios/${usuarioActual?.id}/tareas").snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot<Map<dynamic, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return const Text(
                    "No Data...",
                  );
                } else {
                  var mapa = snapshot.data?.docs;
                  return FutureBuilder<Map<dynamic, dynamic>>(
                    future: obtenerMateriasYTareas(user),
                    builder: (context, AsyncSnapshot<Map<dynamic, dynamic>> projectSnap) {
                      var materiasYTareas = projectSnap.data;
                      if (materiasYTareas != null) {
                        mapa?.forEach((element) {
                          if (element.get("materia") != null && element.get("nombre") != null) {
                            materiasYTareas[element.get("materia")] = element;
                          }
                        });
                      }
                      if (projectSnap.connectionState == ConnectionState.none || materiasYTareas == null) {
                        return Container();
                      }
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: materiasYTareas.length,
                        itemBuilder: (context, index) {
                          String key = materiasYTareas.keys.elementAt(index);

                          return Card(
                            child: ExpansionTile(
                              title: Text(key),
                              trailing: Icon(
                                customTileExpanded ? Icons.arrow_drop_down_circle : Icons.arrow_drop_down,
                              ),
                              onExpansionChanged: (bool expanded) {
                                setState(() => customTileExpanded = expanded);
                              },
                              children: obtenerWidgetListaTareas(materiasYTareas[key]),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              }),
          const ElevatedButton(
            onPressed: cerrarSesion,
            child: Text('Cerrar sesión'),
          ),
          ElevatedButton(
            child: const Text('Recargar'),
            onPressed: () => obtenerMateriasYTareas(user),
          ),
          ElevatedButton(
            child: const Text('AgregarTarea'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AgregarTarea()),
              );
            },
          ),
        ],
      ));
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const <Widget>[
          Text('No has iniciado sesión.'),
          ElevatedButton(
            onPressed: iniciarSesion,
            child: Text('Iniciar sesión con Google'),
          ),
        ],
      );
    }
  }
}
