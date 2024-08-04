import 'package:flutter/material.dart';
import 'package:vacancy_admin/screens/homescreen/home_screen.dart';
import 'package:vacancy_admin/utils/constants.dart';
import 'package:vacancy_admin/utils/utils.dart';

class AuthProvider extends ChangeNotifier {
  bool _loading = false;

  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void checkPassword(
      {required TextEditingController passwordController,
      required BuildContext context}) {
    setLoading(true);
    try {
      if (passwordController.text == Constants.loginPassword) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        Utils.toastMessage(message: 'Please provide correct password');
      }
    } catch (e) {
      Utils.toastMessage(message: e.toString());
    } finally {
      setLoading(false);
    }
  }
}
