import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:image_picker/image_picker.dart';

class UplaodPicture extends StatefulWidget {
  const UplaodPicture({Key? key}) : super(key: key);

  @override
  State<UplaodPicture> createState() => _UplaodPictureState();
}

class _UplaodPictureState extends State<UplaodPicture> {
  final ImagePicker _picker = ImagePicker();
  final _navigator = locator<CustomNavigationService>();
  XFile? image;
  XFile? result;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
            leading: const Icon(Icons.camera),
            title: Text(
              'Prendre une image depuis votre appareil photo',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 13.0,
              ),
            ),
            onTap: () async {
              image = await _picker.pickImage(source: ImageSource.camera);
              setState(() {
                result = image;
              });
              _navigator.goBack(value: image);
            }),
        ListTile(
          leading: const Icon(FontAwesomeIcons.folder),
          title: Text(
            'Sélectionnez une photo dans votre galerie',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 13.0,
            ),
          ),
          onTap: () async {
            image = await _picker.pickImage(
              source: ImageSource.gallery,
            );
            setState(() {
              result = image;
            });

            _navigator.goBack(value: image);
          },
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
}
