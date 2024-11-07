import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:practica_5/firebase/database_movies.dart';
import 'package:practica_5/models/moviesdao.dart';
import 'package:practica_5/settings/global_values.dart';
import 'package:quickalert/quickalert.dart';

class NewMoviewViewFirebase extends StatefulWidget {
  final String? Uid;
  NewMoviewViewFirebase({super.key, this.moviesDAO, this.Uid});

  MoviesDAO? moviesDAO;

  @override
  State<NewMoviewViewFirebase> createState() => _NewMoviewViewFirebaseState();
}

class _NewMoviewViewFirebaseState extends State<NewMoviewViewFirebase> {
  TextEditingController conName = TextEditingController();
  TextEditingController conOverview = TextEditingController();
  TextEditingController conImgMovie = TextEditingController();
  TextEditingController conRelease = TextEditingController();
  DatabaseMovies? dbMovies;

  @override
  void initState() {
    super.initState();
    dbMovies = DatabaseMovies();

    if (widget.moviesDAO != null) {
      conName.text = widget.moviesDAO!.nameMovie!;
      conOverview.text = widget.moviesDAO!.overview!;
      conImgMovie.text = widget.moviesDAO!.imgMovie!;
      conRelease.text = widget.moviesDAO!.releaseDate!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final txtNameMovie = TextFormField(
      controller: conName,
      decoration: const InputDecoration(
        hintText: 'Nombre de la pelicula',
      ),
    );
    final txtOverview = TextFormField(
      controller: conOverview,
      maxLines: 5,
      decoration: const InputDecoration(
        hintText: 'Sinapsis',
      ),
    );
    final txtImageMovie = TextFormField(
      controller: conImgMovie,
      decoration: const InputDecoration(
        hintText: 'Imagen',
      ),
    );
    final txtRelease = TextFormField(
      readOnly: true,
      controller: conRelease,
      decoration: const InputDecoration(
        hintText: 'Fecha lanzamiento',
      ),
      onTap: () async {
        DateTime? pickerDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2024),
          lastDate: DateTime(2050),
        );

        if (pickerDate != null) {
          String formatDame = DateFormat('dd-MM-yyyy').format(pickerDate);
          conRelease.text = formatDame;
          setState(() {});
        } else {}
      },
    );

    final btnGuardar = ElevatedButton(
      onPressed: () {
        if (widget.moviesDAO == null) {
          dbMovies!.insertar({
            "nameMovie": conName.text,
            "overview": conOverview.text,
            "imgageMovie": conImgMovie.text,
            "releaseDate": conRelease.text
          }).then((value) {
            if (value) {
              return QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                text: 'Transaction Completed Successfully!',
                autoCloseDuration: const Duration(seconds: 2),
                showConfirmBtn: false,
              );
            } else {
              return QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: 'Something was wrong',
                autoCloseDuration: const Duration(seconds: 2),
                showConfirmBtn: false,
              );
            }
          });
        } else {
          dbMovies!.Update({
            "idMovie": widget.moviesDAO!.idMovie,
            "nameMovie": conName.text,
            "overview": conOverview.text,
            "idGenre": 1,
            "imgageMovie": conImgMovie.text,
            "releaseDate": conRelease.text
          }, widget.Uid!).then((value) {
            String msj = '';
            QuickAlertType type;
            if (value) {
              GlobalValues.banUpdListMoviews.value =
                  !GlobalValues.banUpdListMoviews.value;
              msj = 'Se actualizo correctamente';
              type = QuickAlertType.success;
            } else {
              msj = 'No se pudo actualizar';
              type = QuickAlertType.error;
            }

            return QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: msj,
              autoCloseDuration: const Duration(seconds: 2),
              showConfirmBtn: false,
            );
          });
        }
      },
      child: const Text('Guardar'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 0, 178, 202),
      ),
    );

    return ListView(
      padding: EdgeInsets.all(15),
      shrinkWrap: true,
      children: [
        txtNameMovie,
        txtOverview,
        txtImageMovie,
        txtRelease,
        btnGuardar
      ],
    );
  }
}
