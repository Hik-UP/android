import 'package:hikup/locator.dart';
import 'package:hikup/model/event.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/base_model.dart';
import 'package:image_picker/image_picker.dart';

class CreateEventViewModel extends BaseModel {
  XFile? image;
  final ImagePicker picker = ImagePicker();
  final navigationService = locator<CustomNavigationService>();

  void getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    image = img;
    notifyListeners();
  }

  createEvent({
    required AppState appState,
    required String title,
    required String description,
    required List<String> tags,
    required String localisation,
  }) async {
    try {
      setState(ViewState.busy);
      await EventModel.createEvent(
        id: appState.id,
        roles: appState.roles,
        title: title,
        description: description,
        coverUrl:
            "https://a.cdn-hotels.com/gdcs/production32/d212/9e18897a-476b-49f2-ba80-06fbd899126a.jpg",
        invitedUser: [],
        tags: tags,
        localisation: localisation,
        nbrParticipants: 0,
        token: appState.token,
      );
      navigationService.goBack();
      setState(ViewState.retrieved);
    } catch (e) {
      setState(ViewState.retrieved);
    }
  }
}
