import 'package:hikup/viewmodel/base_model.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfilModel extends BaseModel {
  XFile? userImage;

  setUserImage({XFile? value}) {
    userImage = value;
    notifyListeners();
  }
}
