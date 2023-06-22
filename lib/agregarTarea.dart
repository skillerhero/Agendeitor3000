// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "iniciarSesionGoogle.dart";

TextEditingController nombreTarea = TextEditingController();
TextEditingController descripcionTarea = TextEditingController();
TextEditingController materia = TextEditingController();
DateTime fecha = DateTime.now();
DateTime selectedDate = DateTime.now();

class AgregarTarea extends StatelessWidget {
  const AgregarTarea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agregar tarea"), centerTitle: true),
      body: Center(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Nombre tarea', hintText: 'Nombre de la tarea'),
              controller: nombreTarea,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Descripción',
                hintText: 'Descripción de la tarea',
              ),
              controller: descripcionTarea,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Materia',
                hintText: 'Materia',
              ),
              controller: materia,
            ),
          ),
          TextButton(
              onPressed: () => _selectDate(context),
              child: const Text(
                'Fecha de entrega',
                style: TextStyle(color: Colors.blue),
              )),
          ElevatedButton(
            onPressed: () => agregarTarea(context),
            child: const Text('Agregar tarea'),
          ),
        ],
      )),
    );
  }
}

Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime.now(), lastDate: DateTime(2100), locale: const Locale("es", "ES"));
  final TimeOfDay? picked2 = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 00, minute: 00));
  if (picked != null && picked != selectedDate) {
    fecha = picked;
    if (picked2 != null) {
      fecha = DateTime(fecha.year, fecha.month, fecha.day, picked2.hour, picked2.minute);
    }
  }
}

void agregarTarea(BuildContext context) {
  CollectionReference collectionReference = FirebaseFirestore.instance.collection("usuarios");
  collectionReference.doc(usuarioActual?.id).collection("tareas").add({"nombre": nombreTarea.text, "descripcion": descripcionTarea.text, "materia": materia.text, "fecha": fecha});

  final snackBar = SnackBar(
    content: const Text('Tarea agregada con éxito'),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Algo de código para ¡deshacer el cambio!
      },
    ),
  );

  // Encuentra el Scaffold en el árbol de widgets y ¡úsalo para mostrar un SnackBar!
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  nombreTarea.text = "";
  descripcionTarea.text = "";
  materia.text = "";
}
