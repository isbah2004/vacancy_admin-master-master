import 'package:flutter/material.dart';
import 'package:vacancy_admin/provider/upload_provider.dart';
import 'package:vacancy_admin/reusablewidgets/reusable_button.dart';
import 'package:vacancy_admin/reusablewidgets/reusable_text_field.dart';
import 'package:vacancy_admin/theme/theme.dart';
import 'package:vacancy_admin/utils/utils.dart';
import 'package:provider/provider.dart';

class AddFile extends StatefulWidget {
  const AddFile({super.key});

  @override
  State<AddFile> createState() => _AddFileState();
}

class _AddFileState extends State<AddFile> {
  final TextEditingController deparmentController = TextEditingController();
  final TextEditingController approvedNumberController =
      TextEditingController();
  final TextEditingController manpowerNumberController =
      TextEditingController();
  final TextEditingController vacancyController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final FocusNode departmentFocusNode = FocusNode();
  final FocusNode approvedNumberFocusNode = FocusNode();
  final FocusNode manpowerNumberFocusNode = FocusNode();
  final FocusNode vacancyFocusNode = FocusNode();
  final FocusNode detailFocusNode = FocusNode();
  final FocusNode numberFocusNode = FocusNode();
  @override
  void dispose() {
    deparmentController.dispose();
    approvedNumberController.dispose();
    manpowerNumberController.dispose();
    vacancyController.dispose();
    detailController.dispose();
    numberController.dispose();
    departmentFocusNode.dispose();
    approvedNumberFocusNode.dispose();
    manpowerNumberFocusNode.dispose();
    vacancyFocusNode.dispose();
    detailFocusNode.dispose();
    numberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Upload Data',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: AppTheme.whiteColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            ReusableTextField(
              hintText: 'Department',
              controller: deparmentController,
              keyboardType: TextInputType.text,
              focusNode: departmentFocusNode,
              onFieldSubmitted: (value) {
                Utils.changeFocus(
                    currentFocus: departmentFocusNode,
                    nextFocus: approvedNumberFocusNode,
                    context: context);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ReusableTextField(
              hintText: 'Approved Numbers',
              controller: approvedNumberController,
              keyboardType: TextInputType.text,
              focusNode: approvedNumberFocusNode,
              onFieldSubmitted: (value) {
                Utils.changeFocus(
                    currentFocus: approvedNumberFocusNode,
                    nextFocus: manpowerNumberFocusNode,
                    context: context);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ReusableTextField(
              hintText: 'Manpower Numbers',
              controller: manpowerNumberController,
              keyboardType: TextInputType.text,
              focusNode: manpowerNumberFocusNode,
              onFieldSubmitted: (value) {
                Utils.changeFocus(
                    currentFocus: manpowerNumberFocusNode,
                    nextFocus: vacancyFocusNode,
                    context: context);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ReusableTextField(
              hintText: 'Vacancy',
              controller: vacancyController,
              keyboardType: TextInputType.text,
              focusNode: vacancyFocusNode,
              onFieldSubmitted: (value) {
                Utils.changeFocus(
                    currentFocus: vacancyFocusNode,
                    nextFocus: detailFocusNode,
                    context: context);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ReusableTextField(maxLines: null,
              hintText: 'Details',
              controller: detailController,
              keyboardType: TextInputType.text,
              focusNode: detailFocusNode,
              onFieldSubmitted: (value) {
                Utils.changeFocus(
                    currentFocus: detailFocusNode,
                    nextFocus: numberFocusNode,
                    context: context);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ReusableTextField(
              hintText: 'Number',
              controller: numberController,
              keyboardType: TextInputType.text,
              focusNode: numberFocusNode,
            ),
            const SizedBox(
              height: 30,
            ),
            Consumer<UploadProvider>(
              builder:
                  (BuildContext context, UploadProvider value, Widget? child) {
                return ReusableButton(
                    title: 'Add Data',
                    onTap: () {
                      value.uploadData(
                          context: context,
                          departmentController: deparmentController,
                          approvedNumberController: approvedNumberController,
                          manpowerNumberController: manpowerNumberController,
                          vacancyController: vacancyController,
                          detailController: detailController,
                          numberController: numberController);
                    },
                    loading: value.loading);
              },
            ),
          ],
        ),
      ),
    );
  }
}
