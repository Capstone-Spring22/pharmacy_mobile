import 'package:flutter/material.dart';

enum CheckoutState { normal, extended }

class CheckoutController extends ChangeNotifier {
  CheckoutState state = CheckoutState.normal;

  void changeCheckoutState(CheckoutState newState) {
    state = newState;
    notifyListeners();
  }
}
