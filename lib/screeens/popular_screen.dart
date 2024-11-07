import 'package:flutter/material.dart';
import 'package:practica_5/models/popular_moviedao.dart';
import 'package:practica_5/network/popular_api.dart';

class PopularScreen extends StatefulWidget {
  const PopularScreen({super.key});

  @override
  State<PopularScreen> createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> {
  PopularApi? popularApi;

  @override
  void initState() {
    super.initState();
    popularApi = PopularApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              // Acción al presionar el ícono "Inicio"
              Navigator.pushNamed(context, '/favoriteList');
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: popularApi!.getPopularMovies(),
        builder: (context, AsyncSnapshot<List<PopularMovieDao>> snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              itemCount: snapshot.data!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return CardPopular(snapshot.data![index]);
              },
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong :()'),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
        },
      ),
      // Aquí está el BottomNavigationBar, solo se agrega una vez en el Scaffold principal
    );
  }

  Widget CardPopular(PopularMovieDao popular) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () =>
            Navigator.pushNamed(context, '/detaill', arguments: popular),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Hero(
            tag: 'movie_${popular.id}', // Usamos el ID de la película como tag
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://image.tmdb.org/t/p/w500/${popular.posterPath}'),
                ),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Opacity(
                    opacity: .7,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                      height: 50,
                      child: Center(
                        child: FittedBox(
                          child: Text(
                            popular.title,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
