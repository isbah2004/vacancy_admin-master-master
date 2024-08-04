import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vacancy_admin/utils/utils.dart';

class UploadProvider extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> uploadData({
    required BuildContext context,
    required TextEditingController departmentController,
    required TextEditingController approvedNumberController,
    required TextEditingController manpowerNumberController,
    required TextEditingController vacancyController,
    required TextEditingController detailController,
    required TextEditingController numberController,
  }) async {
    try {
      setLoading(true);
      await firestore.collection('vacancies').add({
        'department': departmentController.text,
        'approved_numbers': approvedNumberController.text,
        'manpower_numbers': manpowerNumberController.text,
        'vacancy': vacancyController.text,
        'details': detailController.text,
        'number': numberController.text,
      }).then((value) {
        Utils.toastMessage(message: 'Data uploaded successfully');
        Navigator.pop(context);
      });
    } catch (e) {
      Utils.toastMessage(message: 'Failed to upload data');
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateData({
    required BuildContext context,
    required String docId,
    required TextEditingController departmentController,
    required TextEditingController approvedNumberController,
    required TextEditingController manpowerNumberController,
    required TextEditingController vacancyController,
    required TextEditingController detailController,
    required TextEditingController numberController,
  }) async {
    try {
      setLoading(true);
      await firestore.collection('vacancies').doc(docId).update({
        'department': departmentController.text,
        'approved_numbers': approvedNumberController.text,
        'manpower_numbers': manpowerNumberController.text,
        'vacancy': vacancyController.text,
        'details': detailController.text,
        'number': numberController.text,
      }).then((value) {
        Utils.toastMessage(message: 'Data updated successfully');
        Navigator.pop(context);
      });
    } catch (e) {
      Utils.toastMessage(message: 'Failed to update data');
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteFile({
    required String docId,
    required BuildContext context,
  }) async {
    try {
      await firestore.collection('vacancies').doc(docId).delete().then((value) {
        Navigator.pop(context);
        Utils.toastMessage(message: 'Data deleted successfully');
      });
    } catch (e) {
      Utils.toastMessage(message: 'Failed to delete data');
    }
  }
}