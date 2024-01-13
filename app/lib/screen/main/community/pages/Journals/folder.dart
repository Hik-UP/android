import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hikup/screen/main/community/pages/Journals/all_journals.dart';
import '../../shared_preferences.dart';
import '../../utils/enums.dart';
import '../Notifications/ftoast_style.dart';

class FolderPage extends StatefulWidget {
  const FolderPage({super.key});

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  SharedPreferencesService sharedPreferences = SharedPreferencesService();
  TextEditingController addCategoryController = TextEditingController();

  List categories = [""];
  int length = 0;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    getCategories();
    fToast = FToast();
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

  setCategories() async {
    String? allCategories =
        await sharedPreferences.getFromSharedPref('all-categories');
    if (allCategories == null) {
      await sharedPreferences.saveToSharedPref(
          'all-categories', jsonEncode(categories));
      return categories;
    } else {
      List setCategories = jsonDecode(allCategories);
      return setCategories;
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
      show();
      showToast(
          fToast, "Category created successfully ", NotificationStatus.success);
      setState(() {});
    } else if (addCategoryController.text.isEmpty) {
    } else {
      categories.add(addCategoryController.text);
      await sharedPreferences.saveToSharedPref(
          'all-categories', jsonEncode(categories));
      show();
      showToast(
          fToast, "Category created successfully ", NotificationStatus.success);
      setState(() {});
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
                      labelText: 'Enter category name',
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
                        'Entrer',
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

  removeCategory(int index) async {
    if (index == 0) {
      fToast.init(context);
      showToast(
          fToast, "Cannot delete this category", NotificationStatus.failure);
    } else {
      String? allCategories =
          await sharedPreferences.getFromSharedPref('all-categories');
      if (allCategories != null) {
        List decodedList = jsonDecode(allCategories);
        decodedList.removeAt(index);
        await sharedPreferences.saveToSharedPref(
            'all-categories', jsonEncode(decodedList));
        show();
        showToast(fToast, "Category successfully deleted",
            NotificationStatus.success);
      }
    }
  }

  deleteWidget() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                  height: 400,
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                      child: Column(children: [
                    FutureBuilder(
                        future: setCategories(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                                child: Text('No categories to display'));
                          } else if (!snapshot.hasData) {
                            return const Center(
                                child: Text("No categories to display"));
                          } else {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                snapshot.data == null
                                    ? const Center(
                                        child: Text("No categories to display"))
                                    : ListView.builder(
                                        padding: const EdgeInsets.only(top: 10),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 15,
                                                  left: 15,
                                                  right: 15),
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Card(
                                                elevation: 1,
                                                margin: EdgeInsets.zero,
                                                color: Colors.grey[100],
                                                child: ListTile(
                                                  // contentPadding: const EdgeInsets.only(left: 8, bottom: 4, top: 2, right: 4),
                                                  title: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Text(
                                                            snapshot
                                                                .data[index],
                                                            maxLines: 1,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      43,
                                                                      55,
                                                                      69),
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                                  trailing: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 15.0),
                                                        child: GestureDetector(
                                                            onTap: () async {
                                                              //confirmDelete(index);
                                                              setState(() {});
                                                            },
                                                            child: const Icon(
                                                              Icons.delete,
                                                              color: Color
                                                                  .fromARGB(
                                                                      137,
                                                                      105,
                                                                      105,
                                                                      105),
                                                              size: 20,
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ));
                                        },
                                      )
                              ],
                            );
                          }
                        })
                  ]))));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 195, 239, 195),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Categories",
              style: TextStyle(
                color: Color.fromARGB(255, 93, 22, 22),
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                deleteWidget();
              },
              child: const Icon(
                Icons.delete,
                color: Colors.black54,
              ),
            )
          ],
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
          child: Wrap(
              direction: Axis.horizontal,
              children: List.generate(categories.length, (index) {
                return Container(
                    width: 119,
                    padding: const EdgeInsets.all(5),
                    child: GestureDetector(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.folder,
                            size: 110,
                            color: Color.fromARGB(255, 64, 86, 104),
                          ),
                          Text(
                            categories[index],
                            maxLines: 3,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800]),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllJournals(
                                    tag: categories[index],
                                  )),
                        );
                      },
                    ));
              }))),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "btn10",
        backgroundColor: const Color.fromARGB(255, 227, 253, 216),
        onPressed: () {
          addCategoryWidget();
          setState(() {
            // Call
          });
        },
        tooltip: 'Add',
        label: const Row(children: [
          Icon(Icons.add),
          SizedBox(
            width: 5,
          ),
          Text("Add a new Category")
        ]),
      ),
    );
  }
}
