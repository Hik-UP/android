import 'package:flutter/widgets.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/viewmodel/base_model.dart';
import 'package:hikup/viewmodel/comments_model.dart';
import 'package:image_picker/image_picker.dart';

class CommunityPageViewModel extends BaseModel {
  final custonNavigationService = locator<CustomNavigationService>();
  final TextEditingController textController = TextEditingController();
  XFile? image;
  final ImagePicker picker = ImagePicker();

  void getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    image = img;
    notifyListeners();
  }

  Future<List<CommentPhoto>> retrieveData({
    required AppState appState,
    required String trailId,
  }) async {
    Map<String, dynamic> body = {
      "user": {"id": appState.id, "roles": appState.roles},
    };

    // final response =
    //     await http.post(
    //         Uri.parse(
    //             'https://pro-hikup.westeurope.cloudapp.azure.com/api/trail/retrieve'),
    //         headers: <String, String>{
    //           'Content-Type': 'application/json',
    //           'Authorization': "Bearer ${appState.token}"
    //         },
    //         body: json);
    // if (response.statusCode == 200) {
    //   final comments = jsonDecode(response.body);
    //   print(comments['trails'][0]['comments']);
    //   final List<dynamic> data = comments['trails'][0]['comments'];
    //   return data
    //       .map((commentPhoto) => CommentPhoto.fromJson(commentPhoto))
    //       .toList()!;
    // } else {
    //   final string = jsonDecode(response.body);
    //   throw Exception(string['error']);
    // }
    return [];
  }

  void submitMessage() async {
    final text = textController.text;
    //final myUserId = supabase.auth.currentUser!.id;
    if (text.isEmpty) {
      return;
    }
    textController.clear();
    try {
      //_sendMessage(_text);
    } catch (_) {
      custonNavigationService.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
  }
}
