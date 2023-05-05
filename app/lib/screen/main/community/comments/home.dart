import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:hikup/widget/header.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hikup/viewmodel/comments_model.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/model/user.dart';

import 'dart:convert';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/service/hive_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:provider/provider.dart';
import 'package:hikup/providers/app_state.dart';

import 'package:hikup/locator.dart';
import 'package:http/http.dart' as http;

const unexpectedErrorMessage = 'Unexpected error occurred.';


class CommunityPage extends StatefulWidget {
  static String routeName = "/community";
  @override
   CommunityPageState createState() => CommunityPageState();
}


  extension ShowSnackBar on BuildContext {
    /// Displays a basic snackbar
      void showSnackBar({
        required String message,
        Color backgroundColor = Colors.white,
      }) {
        ScaffoldMessenger.of(this).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
        ));
      }
      void showErrorSnackBar({required String message}) {
        showSnackBar(message: message, backgroundColor: Colors.red);
      }
  }


class CommunityPageState extends State<CommunityPage> {
  late final TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    _retrieveData();
    super.initState();
  }

  XFile? image;
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      image = img;
    });
  }

Future<List<CommentPhoto>> _retrieveData() async {
  final Box<User> boxUser = Hive.box("userBox");
  var user = boxUser.get("user");
  String id = user?.id ?? "";
  print("user : " + id);
  List<dynamic> roles = user?.roles ?? [];
  String token = user?.token ?? "";
  String json = "{\"user\": {\"id\": \"" + id +"\",\"roles\": [\""+ roles[0]+"\"]}}";
  final response = await http.post(Uri.parse('https://pro-hikup.westeurope.cloudapp.azure.com/api/trail/retrieve'),
     headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': "Bearer " + token
    },
    body: json
  );
  if (response.statusCode == 200) {
    final comments = jsonDecode(response.body);
    print(comments['trails'][0]['comments']);
    final List<dynamic> data = comments['trails'][0]['comments'];
    return data.map((commentPhoto) => CommentPhoto.fromJson(commentPhoto)).toList()!;
  } else {
    final string = jsonDecode(response.body);
    throw Exception(string['error']);
  }
}

//void _sendMessage(_text){
//  final response = await http.get(Uri.parse('https://myapi.com/mylist'));
//
//}


void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) { 
        return MaterialApp(
        home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const Header(),
        body:  SafeArea(
          child: Column(
            children:[
            Expanded(
            child: ListView(
          shrinkWrap: true,
          children:  [
            FutureBuilder<List<CommentPhoto>>(
            future: _retrieveData(),
            builder: (context, snapshot) {
            if (snapshot.hasData){ 
            List<CommentPhoto> commentsPhotos = snapshot.data!;
            return ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(), 
                itemCount: commentsPhotos.length,
                itemBuilder: (context, index) {
                CommentPhoto commentPhoto = commentsPhotos[index];
                return Card(
                  child: Column(
                    children: [
                      Text(commentPhoto.username , style: TextStyle(fontSize: 20)),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(commentPhoto.body, style: TextStyle(fontSize: 15)),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(), 
                        itemCount: commentPhoto.pictures.length,
                        itemBuilder: (BuildContext context, index) {
                        String pictures = commentPhoto.pictures[index];
                        return Image.network(pictures);
                        }),
                    ]),
                  );
                }); } 
                else if (snapshot.hasError) { 
                  return Text('${snapshot.error}');
                } else {
                  return Center(child: CircularProgressIndicator());
                }
            })])),
            Expanded(
                child: Align(
                alignment: Alignment.bottomCenter,
                child:
                Container(
                          width: 350,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(color: Color(0xffEDEDED), borderRadius: BorderRadius.circular(20)),
                          child: Stack(children: [
                          TextFormField(
                            keyboardType: TextInputType.text,
                            maxLines: null,
                            autofocus: true,
                            controller: _textController,
                            decoration: const InputDecoration(
                              hintText: 'Type a message',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.black26),
                          ),
                        ), 
                         Positioned(bottom: 0,right: 0,child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [ 
                          IconButton(color: Colors.green, onPressed: () => _submitMessage(), icon: Icon(Icons.send_outlined)),
                          IconButton(color: Colors.green,  onPressed: () { myAlert();}, icon: Icon(Icons.camera_alt)),
                        ]
                  )
                )]))))]))),
              debugShowCheckedModeBanner: false,
    );
  }

  void _submitMessage() async {
    final text = _textController.text;
    //final myUserId = supabase.auth.currentUser!.id;
    if (text.isEmpty) {
      return;
    }
    _textController.clear();
    try {
      //_sendMessage(_text);
    } catch (_) {
      context.showErrorSnackBar(message: unexpectedErrorMessage);
    }
  }

    //Widget checkoutListBuilder(snapshot) {
    //return ListView.builder(
    //  itemCount: snapshot.data.length,
    //  itemBuilder: (BuildContext context, i) {
    //    final commentList = snapshot.data[i];
    //    return ListTile(
    //      title: Text(commentList.name),
    //      subtitle: Text("${cartList[i]['price']}\$"),
    //      trailing: IconButton(
    //        icon: Icon(Icons.remove_shopping_cart),
    //        onPressed: () {
    //          bloc.removeFromCart(commentList[i]);
    //        },
    //      ),
    //      onTap: () {},
    //    );
    //  },
    //);
  //}

}
