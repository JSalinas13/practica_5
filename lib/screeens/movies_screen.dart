import 'package:flutter/material.dart';
import 'package:practica_5/database/movies_database.dart';
import 'package:practica_5/models/moviesdao.dart';
import 'package:practica_5/settings/global_values.dart';
import 'package:practica_5/views/movie_view_item.dart';
import 'package:practica_5/views/new_moview_view.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  late MoviesDatabase moviesDB;

  @override
  void initState() {
    super.initState();
    moviesDB = MoviesDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies list'),
        actions: [
          IconButton(
              onPressed: () {
                WoltModalSheet.show(
                  context: context,
                  pageListBuilder: (context) => [
                    WoltModalSheetPage(
                      child: NewMoviewView(),
                    ),
                  ],
                );
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: GlobalValues.banUpdListMoviews,
          builder: (context, value, widget) {
            return FutureBuilder(
                future: moviesDB.SELECT(),
                builder: (context, AsyncSnapshot<List<MoviesDAO>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return MovieViewItem(moviesDAO: snapshot.data![index]);
                      },
                    );
                  } else {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Something was wrong! :)'),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                });
          }),
    );
  }
}
