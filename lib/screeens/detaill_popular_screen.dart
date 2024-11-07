import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:practica_5/models/popular_moviedao.dart';
import 'package:practica_5/network/popular_api.dart';
import 'package:practica_5/provider/test_provider.dart';
import 'package:provider/provider.dart';
import 'package:user_social_profile/user_social_profile.dart';

class DetaillPopularScreen extends StatefulWidget {
  const DetaillPopularScreen({super.key});

  @override
  State<DetaillPopularScreen> createState() => _DetaillPopularScreenState();
}

class _DetaillPopularScreenState extends State<DetaillPopularScreen> {
  PopularApi? popularApi;
  Map<String, dynamic>? actores;
  Map<String, dynamic>? trailer;
  bool isLoading = true; // Variable para manejar el estado de carga
  String? errorMessage; // Variable para manejar errores
  PopularMovieDao? popular; // Declaración de popular

  @override
  void initState() {
    super.initState();
    popularApi = PopularApi();
  }

  @override
  Widget build(BuildContext context) {
    // Obtener el argumento `popular` dentro del build para evitar problemas
    if (popular == null) {
      popular = ModalRoute.of(context)!.settings.arguments as PopularMovieDao?;
    }

    // Validación para asegurarse de que 'popular' no es nulo
    if (popular == null) {
      return Scaffold(
        body: Center(
          child: Text('No se encontraron datos para mostrar.'),
        ),
      );
    }

    // Inicialización de los datos después de obtener el argumento
    if (isLoading) {
      initializeData(popular!);
      getActores(popular!.id);
    }

    // print('Trailers: ${trailer!['key']}');
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popularApi!.addToFavorites('11470588', popular!.id, true);
        },
        child: Icon(Icons.favorite),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Imagen de la película

            Hero(
              tag:
                  'movie_${popular!.id}', // El mismo tag utilizado en PopularScreen
              child: Container(
              height: 300, // Especifica una altura para la imagen
              decoration: BoxDecoration(
                image: DecorationImage(
                  opacity: .7,
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      'https://image.tmdb.org/t/p/w500/${popular!.posterPath}'),
                ),
              ),
            ),
            ),
            
            
            SizedBox(height: 20), // Espaciado
            // Perfil Social del Usuario
            Center(
              child: Column(
                children: [
                  UserSocialProfile(
                    fullName: popular!.title,
                    picture:
                        'https://image.tmdb.org/t/p/w500/${popular!.backdropPath}',
                    icons: [],
                    email: popular!.overview,
                    phone: "",
                    reiting: popular!.voteAverage,
                    trailer: trailer != null ? trailer!['key'] : null,
                  ),
                  SizedBox(height: 20), // Espaciado
                  // Sección de Actores
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: isLoading
                        ? CircularProgressIndicator() // Indicador de carga
                        : errorMessage != null
                            ? Text(
                                errorMessage!,
                                style: TextStyle(color: Colors.red),
                              ) // Mostrar mensaje de error
                            : actores != null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Actores Principales',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10),
                                      // Lista de Actores (modificada a horizontal)
                                      Container(
                                        height:
                                            150, // Ajusta la altura según lo necesites
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis
                                              .horizontal, // Cambiar a horizontal
                                          physics:
                                              BouncingScrollPhysics(), // Establecer la física de desplazamiento
                                          itemCount: actores!['cast']
                                              .length, // Ajusta según tu estructura de datos
                                          itemBuilder: (context, index) {
                                            var actor = actores!['cast'][
                                                index]; // Ajusta según tu estructura
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right:
                                                      8.0), // Espaciado entre elementos
                                              child: Column(
                                                children: [
                                                  actor['profile_path'] != null
                                                      ? CircleAvatar(
                                                          radius:
                                                              40, // Tamaño del avatar
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  'https://image.tmdb.org/t/p/w200/${actor['profile_path']}'),
                                                        )
                                                      : CircleAvatar(
                                                          radius: 40,
                                                          child: Icon(
                                                              Icons.person),
                                                        ),
                                                  SizedBox(
                                                      height:
                                                          5), // Espaciado entre el avatar y el nombre
                                                  Text(
                                                    actor['name'] ??
                                                        'Sin Nombre',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  Text(
                                                    actor['character'] ??
                                                        'Personaje',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : Text('No se encontraron actores.'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initializeData(PopularMovieDao popular) async {
    try {
      setState(() => isLoading = true);

      // Obtener los actores

      // Obtener el trailer
      trailer = await popularApi!.fetchTrailer(popular.id);
    } catch (e) {
      errorMessage = 'Sin trailer';
      // getActores(popular.id);
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> getActores(int id) async {
    try {
      var result = await popularApi!.fetchCredits(id);
      print('RESULT ACTORES: $actores');
      if (mounted) {
        setState(() {
          actores = result; // Guarda los actores obtenidos
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error obteniendo actores: $e");
      if (mounted) {
        setState(() {
          errorMessage = "Error al cargar actores.";
          isLoading = false;
        });
      }
    }
  }
}
