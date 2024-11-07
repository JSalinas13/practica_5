import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practica_5/views/forms_view_item.dart';
import 'package:user_social_profile/user_social_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  String _fullName = "Jesus Salinas";
  String _email = "20030389@itcelaya.edu.mx";
  String _phone = "4616067604";
  bool _showForm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _showForm = true;
              });
              _showFullScreenForm();
            },
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // UserSocialProfile en el fondo
          UserSocialProfile(
            fullName: _fullName,
            picture: '',
            icons: [
              icon(Platform.github),
            ],
            email: _email,
            phone: _phone,
            reiting: 0,
          ),
          // Imagen de perfil en formato circular
          Positioned(
            top: 0,
            child: ClipOval(
              child: SizedBox(
                width: 170.0,
                height: 170.0,
                child: _profileImage != null
                    ? Image.file(
                        _profileImage!,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        'https://avatars.githubusercontent.com/u/89615727?v=4',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          // Botón para cambiar la imagen de perfil
          Positioned(
            top: 0,
            child: ClipOval(
              child: Container(
                width: 170.0,
                height: 170.0,
                color: Colors.transparent,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.white.withOpacity(0.6),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () => _showImageSourceSelector(context),
                  child: const Icon(Icons.camera_alt),
                ),
              ),
            ),
          ),
          // Botón para editar el perfil (visible solo cuando _showForm es false)
        ],
      ),
    );
  }

  SocialIcon icon(String param) => SocialIcon(
        name: param,
        link: "https://github.com/JSalinas13/DesarrolloMoviles.git",
        iconSize: 45,
      );

  void _showImageSourceSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Tomar foto'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Seleccionar desde la galeria'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _showFullScreenForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context)
                .unfocus(); // Dismiss keyboard when tapping outside
          },
          child: Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: MyForm(
              initialFullName: _fullName,
              initialEmail: _email,
              initialPhone: _phone,
              onSave: (fullName, email, phone) {
                setState(() {
                  _fullName = fullName;
                  _email = email;
                  _phone = phone;
                });
                Navigator.of(context).pop();
                setState(() {
                  _showForm = false;
                });
              },
            ),
          ),
        );
      },
    );
  }
}
