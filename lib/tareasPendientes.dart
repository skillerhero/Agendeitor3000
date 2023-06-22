import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis/shared.dart';
import 'classroom.dart';
import 'agregarTarea.dart';
import 'iniciarSesionGoogle.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/classroom/v1.dart';

class TareasPendientesWidget extends StatefulWidget {
  const TareasPendientesWidget({Key? key}) : super(key: key);
  @override
  State createState() => WidgetSate();
}

class WidgetSate extends State<TareasPendientesWidget> {
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
          title: const Text('Prueba de classroom'),
        ),
        body: ConstrainedBox(constraints: const BoxConstraints.expand(), child: buildBody()));
  }

  Widget buildBody() {
    final GoogleSignInAccount? user = usuarioActual;
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
                  return FutureBuilder<ListCourseWorkResponse>(
                    future: obtenerTareas(user),
                    builder: (context, AsyncSnapshot<ListCourseWorkResponse> projectSnap) {
                      var homework = projectSnap.data;
                      if (homework != null) {
                        mapa?.forEach((element) {
                          if (element.get("materia") != null && element.get("nombre") != null) {
                            homework.courseWork?.add(CourseWork(title: element.get("nombre"), dueDate: $Date(day: element.get("fecha").toDate().day, month: element.get("fecha").toDate().month, year: element.get("fecha").toDate().year), dueTime: $TimeOfDay(hours: element.get("fecha").toDate().hour, minutes: element.get("fecha").toDate().minute)));
                          }
                        });
                      }

                      if (projectSnap.connectionState == ConnectionState.none || homework == null || homework.courseWork == null) {
                        return Container();
                      }
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: homework.courseWork?.length,
                        itemBuilder: (context, index) {
                          return TileTareas(homework.courseWork![index]);
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
            onPressed: () => obtenerTareas(user),
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
