import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hikup/screen/main/community/pages/Journals/all_checklists.dart';
import 'package:hikup/screen/main/community/shared_preferences.dart';
import '../../utils/enums.dart';
import '../Notifications/ftoast_style.dart';
import 'add_event.dart';

class ComePage extends StatefulWidget {
  static String routeName = "/community";
  const ComePage({super.key});

  @override
  State<ComePage> createState() => _HomePageState();
}

class _HomePageState extends State<ComePage> {
  SharedPreferencesService sharedPreferences = SharedPreferencesService();
  TextEditingController addChecklistController = TextEditingController();

  List<dynamic> journals = [];
  late Widget profileIcon;
  late String? name = "";
  late FToast fToast;
  String emoticon = "129489";

  var appState;

  get model => null;

  @override
  void initState() {
    super.initState();
    setName();
    fToast = FToast();
  }

  setName() async {
    String? userName = await sharedPreferences.getFromSharedPref("user-name");
    setState(() {
      name = userName;
    });
  }

  setJournals() async {
    String? allJournals =
        await sharedPreferences.getFromSharedPref('user-journals');
    if (allJournals != null) {
      List<dynamic> notesDecoded = jsonDecode(allJournals);
      List reversedList = List.from(notesDecoded.reversed);
      return reversedList;
    }
  }

  setChecklists() async {
    String? allChecklists =
        await sharedPreferences.getFromSharedPref('all-checklist');
    if (allChecklists != null) {
      List<dynamic> taskDecoded = jsonDecode(allChecklists);
      List reversedList = List.from(taskDecoded.reversed);
      if (reversedList.length > 3) {
        var myRange = reversedList.getRange(0, 3).toList();
        return myRange;
      } else {
        return reversedList;
      }
    }
  }

  removeNote(int index) async {
    String? allNotes =
        await sharedPreferences.getFromSharedPref('user-journals');
    if (allNotes != null) {
      List notesDecoded = jsonDecode(allNotes);
      List notesReversed = List.from(notesDecoded.reversed);
      notesReversed.removeAt(index);
      List finalList = List.from(notesReversed.reversed);
      await sharedPreferences.saveToSharedPref(
          'user-journals', jsonEncode(finalList));
      setState(() {});
    }
  }

  removeItem(int index) async {
    String? allChecklists =
        await sharedPreferences.getFromSharedPref('all-checklist');
    if (allChecklists != null) {
      List decodedList = jsonDecode(allChecklists);
      List reversedList = List.from(decodedList.reversed);
      reversedList.removeAt(index);
      List finalList = List.from(reversedList.reversed);
      await sharedPreferences.saveToSharedPref(
          'all-checklist', jsonEncode(finalList));
      setState(() {});
    }
  }

  void show() {
    fToast.init(context);
  }

  taskUpdation(int index) async {
    String? allChecklists =
        await sharedPreferences.getFromSharedPref('all-checklist');
    if (allChecklists != null) {
      List<dynamic> taskDecoded = jsonDecode(allChecklists);
      List reversedList = List.from(taskDecoded.reversed);
      reversedList.removeAt(index);
      await sharedPreferences.saveToSharedPref(
          'all-checklist', jsonEncode(reversedList));
      show();
      showToast(fToast, "Task1 added to the task list successfully ",
          NotificationStatus.success);
    }
  }

  submitCheckLists() async {
    if (addChecklistController.text.isEmpty) {
      fToast.init(context);
      showToast(fToast, "Cette section ne peut pas etre vide",
          NotificationStatus.failure);
    } else {
      String? allChecklists =
          await sharedPreferences.getFromSharedPref('all-checklist');
      if (allChecklists != null) {
        List decodedChecklists = jsonDecode(allChecklists);
        decodedChecklists.add(addChecklistController.text);
        await sharedPreferences.saveToSharedPref(
            'all-checklist', jsonEncode(decodedChecklists));
        show();
        showToast(fToast, "L'événement a été crée", NotificationStatus.success);
        setState(() {});
      } else {
        List checklist = [];
        checklist.add(addChecklistController.text);
        await sharedPreferences.saveToSharedPref(
            'all-checklist', jsonEncode(checklist));
        show();
        showToast(fToast, "Task3 added to the task list successfully ",
            NotificationStatus.success);
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 206, 218, 207),
      // appBar: AppBar(
      //   elevation: 0,
      // ),
      body: ListView(children: [
        // SizedBox(
        //     height: MediaQuery.of(context).size.height * 0.45,
        //     child: SingleChildScrollView(
        //         child: Column(
        //             mainAxisAlignment: MainAxisAlignment.start,
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //           GestureDetector(
        //             onTap: () {
        //               setState(() {});
        //             },
        //             child: Container(
        //               padding: const EdgeInsets.only(
        //                   left: 20, top: 3, bottom: 10, right: 20),
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 // children: [
        //                 //   const Text(
        //                 //     "Toutes les demandes",
        //                 //     style: TextStyle(
        //                 //         fontSize: 18,
        //                 //         fontWeight: FontWeight.bold,
        //                 //         color: Color.fromARGB(255, 52, 63, 71)),
        //                 //   ),
        //                 //   Row(
        //                 //     children: const [
        //                 //       Text(
        //                 //         "Refresh",
        //                 //         style: TextStyle(
        //                 //             fontSize: 17,
        //                 //             fontWeight: FontWeight.bold,
        //                 //             color: Color.fromARGB(255, 86, 127, 160)),
        //                 //       ),
        //                 //       Icon(Icons.refresh,
        //                 //           size: 17,
        //                 //           color: Color.fromARGB(255, 86, 127, 160))
        //                 //     ],
        //                 //   )
        //                 // ],
        //               ),
        //             ),
        //           ),
        //           FutureBuilder(
        //               future: setJournals(),
        //               builder: (context, AsyncSnapshot snapshot) {
        //                 if (snapshot.hasError) {
        //                   return const Center(
        //                       child: Text('No notes to display'));
        //                 } else if (!snapshot.hasData) {
        //                   return const Center(
        //                       child: Text(""));
        //                 } else {
        //                   return Container(
        //                       margin: const EdgeInsets.only(left: 8, right: 8),
        //                       // decoration: BoxDecoration(
        //                       //   borderRadius: BorderRadius.circular(15),
        //                       //   color: Color.fromARGB(255, 189, 220, 179)
        //                       // ),
        //                       child: Column(
        //                           mainAxisAlignment: MainAxisAlignment.start,
        //                           crossAxisAlignment: CrossAxisAlignment.start,
        //                           children: [
        //                             ListView.builder(
        //                                 padding: const EdgeInsets.only(top: 10),
        //                                 physics:
        //                                     const NeverScrollableScrollPhysics(),
        //                                 shrinkWrap: true,
        //                                 itemCount: snapshot.data.length,
        //                                 itemBuilder: (context, index) {
        //                                   //setProfileIcons(snapshot.data[index]);
        //                                   return Container(
        //                                       margin: const EdgeInsets.only(
        //                                           bottom: 15,
        //                                           left: 10,
        //                                           right: 10),
        //                                       height: 79,
        //                                       decoration: BoxDecoration(
        //                                         borderRadius:
        //                                             BorderRadius.circular(10),
        //                                       ),
        //                                       child: GestureDetector(
        //                                           onTap: () {
        //                                             Navigator.push(
        //                                                 context,
        //                                                 MaterialPageRoute(
        //                                                     builder:
        //                                                         (context) =>
        //                                                             EditPage(
        //                                                               title: snapshot
        //                                                                       .data[index]
        //                                                                   [
        //                                                                   "title"],
        //                                                               body: snapshot
        //                                                                       .data[index]
        //                                                                   [
        //                                                                   "body"],
        //                                                               tag: snapshot
        //                                                                       .data[index]
        //                                                                   [
        //                                                                   "tags"],
        //                                                               index:
        //                                                                   index,
        //                                                             )));
        //                                           },
        //                                           child: Card(
        //                                             elevation: 1,
        //                                             margin: EdgeInsets.zero,
        //                                             color: Colors.grey[100],
        //                                             child: ListTile(
        //                                               contentPadding:
        //                                                   const EdgeInsets.only(
        //                                                       left: 8,
        //                                                       bottom: 4,
        //                                                       top: 2,
        //                                                       right: 4),
        //                                               title: Row(
        //                                                 mainAxisAlignment:
        //                                                     MainAxisAlignment
        //                                                         .start,
        //                                                 children: [
        //                                                   Padding(
        //                                                     padding:
        //                                                         const EdgeInsets
        //                                                                 .only(
        //                                                             bottom: 6.0,
        //                                                             top: 2.0),
        //                                                     child: ClipRRect(
        //                                                       borderRadius:
        //                                                           BorderRadius
        //                                                               .circular(
        //                                                                   5.0),
        //                                                       child: Container(
        //                                                         height: 60.0,
        //                                                         width: 60.0,
        //                                                         color: Colors
        //                                                             .grey[300],
        //                                                         //child: profileIcon,
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                   const SizedBox(
        //                                                       width: 10),
        //                                                   Expanded(
        //                                                     child: Text(
        //                                                       snapshot.data[
        //                                                               index]
        //                                                           ["title"],
        //                                                       maxLines: 1,
        //                                                       style: const TextStyle(
        //                                                           fontSize:
        //                                                               17.0,
        //                                                           color: Colors
        //                                                               .black,
        //                                                           fontWeight:
        //                                                               FontWeight
        //                                                                   .bold),
        //                                                     ),
        //                                                   ),
        //                                                   Row(children: [
        //                                                     Padding(
        //                                                       padding:
        //                                                           const EdgeInsets
        //                                                                   .only(
        //                                                               right:
        //                                                                   8.0,
        //                                                               left: 5),
        //                                                       child:
        //                                                           GestureDetector(
        //                                                               onTap:
        //                                                                   () {
        //                                                                 Navigator
        //                                                                     .push(
        //                                                                   context,
        //                                                                   MaterialPageRoute(
        //                                                                       builder: (context) => EditPage(
        //                                                                             title: snapshot.data[index]["title"],
        //                                                                             body: snapshot.data[index]["body"],
        //                                                                             tag: snapshot.data[index]["tags"],
        //                                                                             index: index,
        //                                                                           )),
        //                                                                 );
        //                                                               },
        //                                                               child:
        //                                                                   const Icon(
        //                                                                 Icons
        //                                                                     .edit,
        //                                                                 color: Color.fromARGB(
        //                                                                     137,
        //                                                                     105,
        //                                                                     105,
        //                                                                     105),
        //                                                                 size:
        //                                                                     22,
        //                                                               )),
        //                                                     ),
        //                                                     Padding(
        //                                                       padding:
        //                                                           const EdgeInsets
        //                                                                   .only(
        //                                                               right:
        //                                                                   5.0),
        //                                                       child:
        //                                                           GestureDetector(
        //                                                               onTap:
        //                                                                   () {
        //                                                                 removeNote(
        //                                                                     index);
        //                                                               },
        //                                                               child:
        //                                                                   const Icon(
        //                                                                 Icons
        //                                                                     .delete,
        //                                                                 color: Color.fromARGB(
        //                                                                     137,
        //                                                                     105,
        //                                                                     105,
        //                                                                     105),
        //                                                                 size:
        //                                                                     22,
        //                                                               )),
        //                                                     ),
        //                                                   ])
        //                                                 ],
        //                                               ),
        //                                             ),
        //                                           )));
        //                                 })
        //                           ]));
        //                 }
        //               })
        //         ]))),
        Column(children: [
          Container(
              padding: const EdgeInsets.only(
                  left: 20, top: 1, bottom: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "List of events",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 52, 63, 71)),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        child: const Text(
                          "",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 86, 127, 160)),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AllChecklist()),
                          );
                        },
                      ),
                    ],
                  )
                ],
              )),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25.0))),
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
                                controller: addChecklistController,
                                decoration: InputDecoration(
                                  labelText: 'Enter your event',
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                  //hintStyle: TextStyle(color: Colors.black),
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
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text(
                                    'Create',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  onPressed: () {
                                    submitCheckLists();
                                    Navigator.pop(context);
                                  },
                                ),
                              )
                            ],
                          ),
                        )));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.fromLTRB(5, 8, 5, 10),
                padding: const EdgeInsets.all(14),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Add event",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 52, 63, 71),
                      ),
                    ),
                    Icon(Icons.add),
                  ],
                ),
              ),
            ),
          ),
          FutureBuilder(
              future: setChecklists(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('error'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text("pas d'événements crée"));
                } else {
                  return Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        //color: Color.fromARGB(255, 27, 235, 34)
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(
                                padding: const EdgeInsets.only(top: 5),
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 8),
                                      height: 43,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Card(
                                        elevation: 1,
                                        margin: EdgeInsets.zero,
                                        color: Colors.grey[100],
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.only(
                                              left: 0, right: 4, bottom: 10),
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child:
                                                    Text(snapshot.data[index],
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              255, 43, 55, 69),
                                                        )),
                                              )
                                            ],
                                          ),
                                          trailing: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 15.0),
                                                child: GestureDetector(
                                                    onTap: () {
                                                      removeItem(index);
                                                    },
                                                    child: const Icon(
                                                      Icons.delete,
                                                      color: Color.fromARGB(
                                                          137, 105, 105, 105),
                                                      size: 20,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                                })
                          ]));
                }
              })
        ])
      ]),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color.fromARGB(255, 14, 191, 41),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddPage()),
            );
            setState(() {});
          },
          label: const Row(
            children: [
              Icon(Icons.share),
              SizedBox(
                width: 5,
              ),
              Text(
                "Share this event",
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              )
            ],
          )),
    );
  }
}
