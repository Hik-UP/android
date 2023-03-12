import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:hikup/widget/header.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
    return  MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const Header(),
        body:  SafeArea(
          child: Column(
          children: [
            Padding(
            padding: const EdgeInsets.only(top: 228.0),
            child:
            image != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(image!.path),
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                      ),
                    ),
                  )
                : Text(
                    "Nothing",
                    style: TextStyle(fontSize: 20),
                )),
                Expanded(child: Align(
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
  // send message to api 
  //  } on PostgrestException catch (error) {
  //   context.showErrorSnackBar(message: error.message);
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