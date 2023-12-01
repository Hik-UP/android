import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:gap/gap.dart";

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
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: Text("Annuler",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  )),
            ),
          ],
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(4.0),
          ),
          title: Text(
            'Sélectionnez le média',
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontStyle: FontStyle.italic),
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 6,
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    getImageGallery();
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.image,
                        color: Colors.white,
                      ),
                      const Gap(5),
                      Text(
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontStyle: FontStyle.italic),
                          'À partir de la gallerie'),
                    ],
                  ),
                ),
                const Gap(15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    getImageCamera();
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.camera, color: Colors.white),
                      const Gap(5),
                      Text(
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontStyle: FontStyle.italic),
                          'À partir de la caméra'),
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
