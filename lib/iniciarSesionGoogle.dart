// ignore_for_file: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Variable global que sirve para guardar la sesión de google con los scopes necesarios
GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: <String>['email', ClassroomApi.classroomCoursesReadonlyScope, ClassroomApi.classroomCourseworkStudentsReadonlyScope, ClassroomApi.classroomCourseworkMeReadonlyScope],
);
GoogleSignInAccount? usuarioActual;
Future<void> iniciarSesion() async {
  try {
    await googleSignIn.signIn();
    // ignore: empty_catches
  } catch (error) {}
}

Future<void> cerrarSesion() => FirebaseAuth.instance.signOut();

// void getUsuarios() async {
//   CollectionReference collectionReference = FirebaseFirestore.instance.collection("usuarios");
//   QuerySnapshot usuarios = await collectionReference.get();
//   if (usuarios.docs.isNotEmpty) {
//     for (var doc in usuarios.docs) {
//       print(doc.data());
//     }
//   }
// }

void agregarUsuario(GoogleSignInAccount user) async {
  CollectionReference collectionReference = FirebaseFirestore.instance.collection("usuarios");

  collectionReference.doc(user.id).set({
    "nombre": user.displayName,
    "correo": user.email,
  });
}

void agregarUsuarioFirebase(User user) async {
  CollectionReference collectionReference = FirebaseFirestore.instance.collection("usuarios");
  collectionReference.doc(user.uid).set({
    "nombre": user.displayName,
    "correo": user.email,
  });
}
