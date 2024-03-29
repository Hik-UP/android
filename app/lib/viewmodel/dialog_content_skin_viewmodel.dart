import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/model/skin.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/service/hive_service.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/base_model.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class DialogContentSkinViewModel extends BaseModel {
  final dioService = locator<DioService>();
  final navigationService = locator<CustomNavigationService>();
  final hiveService = locator<HiveService>();
  bool isLoading = false;
  dynamic paymentIntent;

  Future<void> changeSkin({
    required AppState appState,
    required String newSkinId,
    required SkinWithOwner skinWithOwner,
  }) async {
    try {
      setState(ViewState.busy);
      await dioService.put(
        path: updateCurrentSkinPath,
        body: {
          'user': {'id': appState.id, 'roles': appState.roles},
          'skin': {
            'id': newSkinId,
          }
        },
        token: 'Bearer ${appState.token}',
      );
      setState(ViewState.retrieved);
      Skin newSkin = Skin(
          id: skinWithOwner.id,
          name: skinWithOwner.name,
          description: skinWithOwner.description,
          pictures: skinWithOwner.pictures,
          model: skinWithOwner.model,
          price: skinWithOwner.price);
      Skin.addSkinOnHive(
        skin: newSkin,
        skinBox: skinUserBox,
      );
      appState.updateSkinState(value: newSkin);
      navigationService.goBack();
    } catch (e) {
      setState(ViewState.retrieved);
      navigationService.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
  }

  void setIsLoading(bool value) {
    isLoading = value;

    notifyListeners();
  }

  createPaymentIntent({
    required String amount,
    required String currency,
  }) async {
    Dio dio = Dio();

    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        options: Options(
          headers: {
            'Authorization': 'Bearer $stripeSecret',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
        ),
        data: body,
      );

      return response.data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  displayPaymentSheet({
    required AppState appState,
    required String skinId,
  }) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        //Clear paymentIntent variable after successful payment
        paymentIntent = null;
        setState(ViewState.busy);
        await dioService.put(
          path: skinUnlockPath,
          body: {
            "user": {
              "id": appState.id,
              "roles": appState.roles,
            },
            "skin": {
              "id": skinId,
            }
          },
          token: 'Bearer ${appState.token}',
        );
        setState(ViewState.retrieved);
        navigationService.goBack();
        navigationService.showSnackBack(
          content: "Achat effectué",
        );
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException {
      navigationService.showSnackBack(
        content: AppMessages.stripeError,
        isError: true,
      );
    }
  }

  Future<void> buySkin({
    required AppState appState,
    required SkinWithOwner skin,
  }) async {
    try {
      setIsLoading(true);
      paymentIntent = await createPaymentIntent(
        amount: (skin.price.toInt() * 100).toString(),
        currency: 'USD',
      );

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          style: ThemeMode.light,
          merchantDisplayName: "Hikup",
        ),
      );

      await displayPaymentSheet(
        appState: appState,
        skinId: skin.id,
      );
      setIsLoading(false);
    } catch (err) {
      setIsLoading(false);
      navigationService.showSnackBack(
        content: AppMessages.paymentCancel,
        isError: true,
      );
    }
  }
}
