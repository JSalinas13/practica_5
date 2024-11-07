import 'package:practica_5/models/trailers_model.dart';
import 'package:practica_5/network/popular_api.dart';
import 'package:flutter/material.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  PopularApi popularApi = PopularApi();
  Map<String, dynamic>? favorito;
  String id_acount = '11470588';

  @override
  void initState() {
    super.initState();
    recuperarFavoritos();
  }

  Future<void> recuperarFavoritos() async {
    final result = await popularApi.getFavoriteMovies(id_acount);
    setState(() {
      favorito = result;
    });
    print('Le da los valores a favorito=$favorito');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAVORITOS'),
      ),
      body: favorito == null
          ? Center(
              child:
                  CircularProgressIndicator()) // Muestra un indicador de carga mientras se espera la data
          : ListView.builder(
              itemCount: favorito?['results']?.length ?? 0,
              itemBuilder: (context, index) {
                final movie = favorito?['results'][index];
                return ListTile(
                  title: Text(movie?['title'] ?? 'Sin título'),
                  subtitle: Text(movie?['overview'] ?? 'Sin descripción'),
                  trailing: IconButton(
                      onPressed: () async {
                        setState(() {});
                      },
                      icon: Icon(Icons.delete_forever)),
                );
              },
            ),
    );
  }
}
