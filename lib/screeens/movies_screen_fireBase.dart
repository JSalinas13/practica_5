import 'package:flutter/material.dart';
import 'package:practica_5/firebase/database_movies.dart';
import 'package:practica_5/views/new_moview_view_firebase.dart';

import 'package:sqflite/sqflite.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class MoviesScreenFirebase extends StatefulWidget {
  const MoviesScreenFirebase({super.key});

  @override
  State<MoviesScreenFirebase> createState() => _MoviesScreenFirebaseState();
}

class _MoviesScreenFirebaseState extends State<MoviesScreenFirebase> {
  DatabaseMovies? databaseMovies;
  @override
  void initState() {
    // TODO: implement initStat
    databaseMovies = DatabaseMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies firebase'),
        actions: [
          IconButton(
              onPressed: () {
                WoltModalSheet.show(
                  context: context,
                  pageListBuilder: (context) => [
                    WoltModalSheetPage(
                      child: NewMoviewViewFirebase(),
                    ),
                  ],
                );
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: StreamBuilder(
        stream: databaseMovies!.Select(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Image.network(
                    snapshot.data!.docs[index].get('imgMovie'));
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('no jalo apa'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
