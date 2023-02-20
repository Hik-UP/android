import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/screen/main/community/shared_preferences.dart';
import 'package:hikup/service/custom_navigation.dart';
import '../../utils/enums.dart';
import '../Notifications/ftoast_style.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  SharedPreferencesService sharedPreferences = SharedPreferencesService();
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  TextEditingController imageLinkController = TextEditingController();
  TextEditingController addCategoryController = TextEditingController();
  Map<String, dynamic> journal = {
    "title": "",
    "body": "",
    "tags": "General",
    "date": null,
    "image": ""
  };
  FToast fToast = FToast();
  bool isLoading = false;
  String icon = "128218";
  String emoticon = "129489";
  late Widget profileIcon = Center(
      child: Text(
    String.fromCharCodes([int.parse(emoticon)]),
    style: const TextStyle(fontSize: 45),
  ));
  String currentCategory = "General";
  List categories = ["General"];
  List<dynamic> journals = [];
  final _navigator = locator<CustomNavigationService>();

  @override
  void initState() {
    super.initState();
    getCategories();
    //setProfileIcons(emoticon);
  }

  getCategories() async {
    String? allCategories =
        await sharedPreferences.getFromSharedPref('all-categories');
    if (allCategories == null) {
      await sharedPreferences.saveToSharedPref(
          'all-categories', jsonEncode(categories));
    } else {
      List setCategories = jsonDecode(allCategories);
      setState(() {
        categories = setCategories;
      });
    }
  }

  void show() {
    fToast.init(context);
  }

  submitCategory() async {
    String? allCategories =
        await sharedPreferences.getFromSharedPref('all-categories');
    if (allCategories == null) {
      await sharedPreferences.saveToSharedPref(
          'all-categories', jsonEncode(categories));
      setState(() {});
    } else if (addCategoryController.text.isEmpty) {
      show();
      showToast(fToast, "Category cannot be empty", NotificationStatus.failure);
    } else {
      categories.add(addCategoryController.text);
      await sharedPreferences.saveToSharedPref(
          'all-categories', jsonEncode(categories));
      setState(() {});
    }
  }

  handleSubmit() async {
    if (titleController.text.isEmpty) {
      fToast.init(context);
      showToast(
          fToast, "Title cannot be left empty", NotificationStatus.failure);
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      String? allJournals =
          await sharedPreferences.getFromSharedPref('user-journals');
      journal["title"] = titleController.text;
      journal["body"] = bodyController.text;
      journal["tags"] = currentCategory;
      journal["date"] = DateTime.now().toIso8601String();
      //journal["image"] = icon;
      if (allJournals == null) {
        journals.add(journal);
        await sharedPreferences.saveToSharedPref(
            'user-journals', jsonEncode(journals));
        show();
        showToast(
            fToast,
            "Notetest created successfully. Please refresh to view your newly created note",
            NotificationStatus.success);
        setState(() {
          isLoading = false;
        });
        _navigator.goBack();
      } else {
        List decoded = jsonDecode(allJournals);
        decoded.add(journal);
        await sharedPreferences.saveToSharedPref(
            'user-journals', jsonEncode(decoded));
        show();
        showToast(
            fToast, "L'invitation a été envoyé.", NotificationStatus.success);
        _navigator.goBack();
      }
    }
  }

  addCategoryWidget() {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: addCategoryController,
                    decoration: InputDecoration(
                      labelText: 'Entrer le nom de la personne',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 115, 115, 115),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 115, 115, 115),
                        ),
                      ),
                    ),
                    autofocus: true,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: const Text(
                        'Rechercher',
                        style: TextStyle(fontSize: 17),
                      ),
                      onPressed: () {
                        submitCategory();
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 213, 240, 209),
        appBar: AppBar(
            title: const Text(
              "Inviter une personne",
              style: TextStyle(color: Colors.black38),
            ),
            backgroundColor: Colors.white),
        floatingActionButton: isLoading
            ? FloatingActionButton.extended(
                onPressed: () {},
                tooltip: 'wait',
                label: const Text("submitting.... please wait"),
              )
            : FloatingActionButton.extended(
                backgroundColor: const Color.fromARGB(255, 160, 239, 168),
                onPressed: () {
                  setState(() {
                    true;
                  });
                  handleSubmit();
                },
                tooltip: 'Add',
                label: Row(children: const [
                  Icon(Icons.add),
                  SizedBox(width: 5),
                  Text("Envoyer")
                ]),
              ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(2, 10, 3, 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: const Color.fromARGB(255, 220, 215, 179)),
                      child: Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 2.0, top: 2.0, left: 5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                              height: 60.0,
                              width: 60.0,
                              color: Colors.white,
                              child: profileIcon,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                left: 15,
                              ),
                              child: const Text(""),
                            ),
                          ],
                        )
                      ]))),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: InputDecorator(
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        child: DropdownButton<String>(
                          style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 0, 0, 0)),
                          autofocus: true,
                          value: currentCategory,
                          items: categories.map<DropdownMenuItem<String>>((t) {
                            return DropdownMenuItem<String>(
                              value: t,
                              child: Text(t),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            currentCategory = newVal!;
                            setState(() {
                              currentCategory = newVal;
                            });
                          },
                        )),
                  ),
                  const SizedBox(
                    width: 25,
                    height: 0,
                  ),
                  GestureDetector(
                    onTap: () {
                      addCategoryWidget();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 196, 225, 195),
                          borderRadius: BorderRadius.circular(5)),
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(right: 13),
                child: TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Entrer le sentier souhaité"),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                  child: TextFormField(
                controller: bodyController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                    hintText: "Ajouter un commentaire",
                    border: InputBorder.none),
              )),
            ],
          ),
        ));
  }
}
