import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:_discoveryapis_commons/_discoveryapis_commons.dart';
import 'package:intl/intl.dart';

Future<Map<dynamic, dynamic>> obtenerMateriasYTareas(GoogleSignInAccount user) async {
  Map materiasYTareas = {};

  Client client = Client();
  ApiRequester apiRequester = ApiRequester(client, "https://classroom.googleapis.com/", "", await user.authHeaders);
  CoursesResource cursos = CoursesResource(apiRequester);
  CoursesCourseWorkResource tareas = CoursesCourseWorkResource(apiRequester);
  var listaCursos = await cursos.list();

  var materias = listaCursos.courses;
  if (materias != null) {
    for (var materia in materias) {
      var id = materia.id;
      if (id != null) {
        materiasYTareas[materia.name] = await tareas.list(id);
      }
    }
  }
  return materiasYTareas;
}

Future<ListCourseWorkResponse> obtenerTareas(GoogleSignInAccount user) async {
  Client client = Client();
  ApiRequester apiRequester = ApiRequester(client, "https://classroom.googleapis.com/", "", await user.authHeaders);
  CoursesResource cursos = CoursesResource(apiRequester);
  CoursesCourseWorkResource tareas = CoursesCourseWorkResource(apiRequester);
  CoursesCourseWorkStudentSubmissionsResource entregas = CoursesCourseWorkStudentSubmissionsResource(apiRequester);

  var listaCursos = await cursos.list();
  ListCourseWorkResponse aux = ListCourseWorkResponse();

  ListStudentSubmissionsResponse homework = ListStudentSubmissionsResponse();
  List<StudentSubmission> aux5 = <StudentSubmission>[];
  homework.studentSubmissions = aux5;

  ListStudentSubmissionsResponse aux6 = ListStudentSubmissionsResponse();

  ListCourseWorkResponse retorno = ListCourseWorkResponse();
  retorno.courseWork = <CourseWork>[];
  List<CourseWork> aux2;
  var materias = listaCursos.courses;
  if (materias != null) {
    for (var materia in materias) {
      var id = materia.id;
      if (id != null) {
        aux = await tareas.list(id);
        aux2 = aux.courseWork!;
        for (CourseWork tarea in aux2) {
          var idTarea = tarea.id;
          if (idTarea != null) {
            aux6 = await entregas.list(id, idTarea);
            var aux7 = aux6.studentSubmissions;
            if (aux7 != null) {
              for (var entrega in aux7) {
                if (entrega.state == "CREATED") {
                  retorno.courseWork?.add(tarea);
                }
              }
            }
          }
        }
      }
    }
  }
  return retorno;
}

List<Widget> obtenerWidgetListaTareas(var tareas) {
  DateTime dt = DateTime.now();
  List<Widget> aux = [];
  if (tareas != null) {
    if (tareas is ListCourseWorkResponse) {
      var y = tareas.courseWork;
      if (y != null) {
        for (CourseWork s in y) {
          String? titulo = s.title;
          String fecha = "";

          if (s.dueDate != null) {
            var month = s.dueDate?.month;
            var day = s.dueDate?.day;
            String mes = "";
            String dia = "";
            if (month != null) {
              if (month < 10) {
                mes = "0$month";
              } else {
                mes = "$month";
              }
            }

            if (day != null) {
              if (day < 10) {
                dia = "0$day";
              } else {
                dia = "$day";
              }
            }

            fecha = "${s.dueDate!.year}-$mes-$dia";
            if (s.dueTime != null) {
              var hours = s.dueTime?.hours;
              var minutes = s.dueTime?.minutes;
              String? horas = "";
              String? minutos = "";
              if (hours != null) {
                if (hours < 10) {
                  horas = "0$hours";
                } else {
                  horas = "$hours";
                }
                if (minutes != null) {
                  if (minutes < 10) {
                    minutos = "0$minutes";
                  } else {
                    minutos = "$minutes";
                  }
                  fecha = "${fecha}T$horas:$minutos";
                }
              }
            }
            dt = DateTime.parse(fecha);
            dt = dt.subtract(const Duration(hours: 5));
            fecha = DateFormat('yyyy-MM-ddTkk:mm').format(dt);
          }

          if (titulo != null) {
            if (dt.compareTo(DateTime.now()) > 0) {
              aux.add(ListTile(
                title: Text(titulo),
                subtitle: Text(fecha),
                leading: const FlutterLogo(),
              ));
            }
          }
        }
      }
    } else {
      String? titulo = tareas.get("nombre");
      dt = tareas.get("fecha").toDate();
      if (titulo != null) {
        if (dt.compareTo(DateTime.now()) > 0) {
          aux.add(ListTile(
            title: Text(titulo),
            subtitle: Text(DateFormat('yyyy-MM-ddTkk:mm').format(dt)),
            leading: const FlutterLogo(),
          ));
        }
      }
    }
  }
  return aux;
}

Widget TileTareas(var tarea) {
  DateTime dt = DateTime.now();
  ListTile? aux = const ListTile();
  if (tarea != null) {
    if (tarea is CourseWork) {
      String? titulo = tarea.title;
      String fecha = "";

      if (tarea.dueDate != null) {
        var month = tarea.dueDate?.month;
        var day = tarea.dueDate?.day;
        String mes = "";
        String dia = "";
        if (month != null) {
          if (month < 10) {
            mes = "0$month";
          } else {
            mes = "$month";
          }
        }

        if (day != null) {
          if (day < 10) {
            dia = "0$day";
          } else {
            dia = "$day";
          }
        }

        fecha = "${tarea.dueDate!.year}-$mes-$dia";
        if (tarea.dueTime != null) {
          var hours = tarea.dueTime?.hours;
          var minutes = tarea.dueTime?.minutes;
          String? horas = "";
          String? minutos = "";
          if (hours != null) {
            if (hours < 10) {
              horas = "0$hours";
            } else {
              horas = "$hours";
            }
            if (minutes != null) {
              if (minutes < 10) {
                minutos = "0$minutes";
              } else {
                minutos = "$minutes";
              }
              fecha = "${fecha}T$horas:$minutos";
            }
          }
        }
        dt = DateTime.parse(fecha);
        dt = dt.subtract(const Duration(hours: 5));
        fecha = DateFormat('yyyy-MM-ddTkk:mm').format(dt);
      }

      if (titulo != null) {
        if (dt.compareTo(DateTime.now()) > 0) {
          aux = (ListTile(
            title: Text(titulo),
            subtitle: Text(fecha),
            leading: const FlutterLogo(),
          ));
        } else if (dt.compareTo(DateTime.now()) == 0) {
          return Container();
          // aux = (ListTile(
          //   title: Text(titulo),
          //   subtitle: Text("Sin fecha de entrega"),
          //   leading: const FlutterLogo(),
          // ));
        } else {
          return Container();
        }
      }
    } else {
      String? titulo = tarea.get("nombre");
      dt = tarea.get("fecha").toDate();
      if (titulo != null) {
        if (dt.compareTo(DateTime.now()) > 0) {
          aux = (ListTile(
            title: Text(titulo),
            subtitle: Text(DateFormat('yyyy-MM-ddTkk:mm').format(dt)),
            leading: const FlutterLogo(),
          ));
        }
      }
    }
  }
  return aux;
}
