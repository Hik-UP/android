import 'package:hikup/viewmodel/base_model.dart';
import 'package:image_picker/image_picker.dart';

class CreateEventViewModel extends BaseModel {
  XFile? image;
  final ImagePicker picker = ImagePicker();

  void getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    image = img;
    notifyListeners();
  }
}
