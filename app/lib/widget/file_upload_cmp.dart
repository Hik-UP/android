import 'package:flutter/material.dart';
import 'package:hikup/theme.dart';

class FileUploadCmp {
  static void myAlert({
    required BuildContext context,
    required Function getImageGallery,
    required Function getImageCamera,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: BlackPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text(
            'Sélectionner le média',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 6,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    getImageGallery();
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.image),
                      Text('À partir de la gallerie'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    getImageCamera();
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.camera),
                      Text('À partir de la caméra'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  
}
