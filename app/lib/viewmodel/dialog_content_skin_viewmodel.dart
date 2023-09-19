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
      print(body);

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

      print(response.data);
      return response.data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        //Clear paymentIntent variable after successful payment
        paymentIntent = null;
        navigationService.goBack();
        navigationService.showSnackBack(
          content: AppMessages.successLabel,
          
        );
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
    } catch (e) {
      print('$e');
    }
  }

  Future<void> buySkin({
    required AppState appState,
    required SkinWithOwner skin,
  }) async {
    try {
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

      displayPaymentSheet();
    } catch (err) {
      print(err);
      navigationService.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
  }
}
