import 'package:flutter/material.dart';
import 'package:practica_5/database/movies_database.dart';
import 'package:practica_5/models/moviesdao.dart';
import 'package:practica_5/settings/global_values.dart';
import 'package:practica_5/views/new_moview_view.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

// class MovieViewItem extends StatelessWidget {
//   MovieViewItem({super.key, required this.moviesDAO});

//   MoviesDAO moviesDAO;

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

class MovieViewItem extends StatefulWidget {
  MovieViewItem({
    super.key,
    required this.moviesDAO,
  });

  MoviesDAO moviesDAO;

  @override
  State<MovieViewItem> createState() => _nameState();
}

class _nameState extends State<MovieViewItem> {
  MoviesDatabase? moviesDatabase;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    moviesDatabase = MoviesDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      height: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromRGBO(255, 255, 255, 15)),
      child: Column(
        children: [
          Row(
            children: [
              Image.network(
                'https://i0.wp.com/plexmx.info/wp-content/uploads/2024/05/deadpool_and_wolverine_ver6_xxlg.jpg?resize=1300%2C1926&ssl=1',
                height: 100,
              ),
              Expanded(
                child: ListTile(
                  title: Text(widget.moviesDAO.nameMovie!),
                  subtitle: Text(widget.moviesDAO.releaseDate!),
                ),
              ),
              IconButton(
                  onPressed: () {
                    WoltModalSheet.show(
                      context: context,
                      pageListBuilder: (context) => [
                        WoltModalSheetPage(
                          child: NewMoviewView(
                            moviesDAO: widget.moviesDAO,
                          ),
                        ),
                      ],
                    );
                  },
                  icon: Icon(Icons.edit)),
              IconButton(
                  onPressed: () {
                    moviesDatabase!
                        .DELETE(
                      'tblMovies',
                      widget.moviesDAO.idMovie!,
                    )
                        .then((value) {
                      if (value > 0) {
                        GlobalValues.banUpdListMoviews.value =
                            !GlobalValues.banUpdListMoviews.value;
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
                  },
                  icon: Icon(Icons.delete)),
            ],
          ),
          Divider(),
          Text(widget.moviesDAO.overview!),
        ],
      ),
    );
  }
}
