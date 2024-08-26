import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:perf_rse/utils/i18n.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../api/supabse_db.dart';
import '../../../../../helper/helper_methods.dart';
import '../../../../../modules/styled_scrollview.dart';
import '../../../../../widgets/custom_text.dart';
import '../../../../../widgets/custom_text_form_field.dart';

class PasswordPilote extends StatefulWidget {
  const PasswordPilote({
    Key? key,
  }) : super(key: key);

  @override
  State<PasswordPilote> createState() => _PasswordPiloteState();
}

class _PasswordPiloteState extends State<PasswordPilote> {
  late TextEditingController currentPassordTextEditingController;
  late TextEditingController newPassordTextEditingController;
  late TextEditingController checkNewPassordTextEditingController;
  final DataBaseController dbController = DataBaseController();
  final storage = const FlutterSecureStorage();
  final RegExp spaceRegex = RegExp(r'\s');
  final _formKey = GlobalKey<FormState>();
  bool containUpperCase = false;
  bool containLowerCase = false;
  bool containDigit = false;
  bool obscureTextNewPassword = false;
  bool obscureTextCheckPassword = false;
  bool obscureTextcurrentPassword = false;

  void updatePassword(context) async {
    EasyLoading.show(status:tr.loadingUpdating);
    final lastPassword = currentPassordTextEditingController.text;
    final newPassword = newPassordTextEditingController.text;
    final checkPassword = checkNewPassordTextEditingController.text;
    final email = await storage.read(key: "email");
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: lastPassword,
      );
      if (newPassword == checkPassword) {
        await dbController.updatePasswordUser(
            email: email!, checkPassWord: checkPassword);
        currentPassordTextEditingController.text = "";
        newPassordTextEditingController.text = "";
        checkNewPassordTextEditingController.text = "";
        ScaffoldMessenger.of(context).showSnackBar(showSnackBar(
            tr.success, tr.passwordSuccessfullyUpdatedMessage, Colors.green));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            showSnackBar(tr.fail, tr.updatingFailMessage, Colors.red));
      }
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(showSnackBar(
          tr.fail,
         tr.passwordIncorrectMessage,
          Colors.red,
          const Duration(seconds: 6)));
    }
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    currentPassordTextEditingController = TextEditingController();
    newPassordTextEditingController = TextEditingController();
    checkNewPassordTextEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StyledScrollView(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Card(
              elevation: 3,
              child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Wrap(
                    spacing: 5,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           CustomText(
                            text: tr.currentPassword,
                            size: 15,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomTextFormField(
                            width: 330,
                            obscureText: obscureTextcurrentPassword,
                            controller: currentPassordTextEditingController,
                            validator: (value) {
                              if (spaceRegex.hasMatch(value!)) {
                                return tr.passwordMustNotContainSpace;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      obscureTextcurrentPassword =
                                          !obscureTextcurrentPassword;
                                    });
                                  },
                                  child: Icon(obscureTextcurrentPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                                hintText:tr.password,
                                prefixIcon: const Icon(Icons.vpn_key_sharp),
                                contentPadding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2))),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           CustomText(
                            text:tr.newPassword,
                            size: 15,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomTextFormField(
                            width: 330,
                            obscureText: obscureTextNewPassword,
                            controller: newPassordTextEditingController,
                            validator: (value) {
                              if (spaceRegex.hasMatch(value!)) {
                                return tr.passwordMustNotContainSpace;
                              }
                              if (value.length < 6) {
                                return tr.passwordLengthMessage;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      obscureTextNewPassword =
                                          !obscureTextNewPassword;
                                    });
                                  },
                                  child: Icon(obscureTextNewPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                                hintText:tr.password,
                                prefixIcon: const Icon(Icons.vpn_key_sharp),
                                contentPadding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2))),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           CustomText(
                            text: tr.confirmPassword,
                            size: 15,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomTextFormField(
                            width: 330,
                            obscureText: obscureTextCheckPassword,
                            controller: checkNewPassordTextEditingController,
                            validator: (value) {
                              if (checkNewPassordTextEditingController.text !=
                                  newPassordTextEditingController.text) {
                                return tr.passwordNoMatch;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      obscureTextCheckPassword =
                                          !obscureTextCheckPassword;
                                    });
                                  },
                                  child: Icon(obscureTextCheckPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                                hintText:tr.password,
                                prefixIcon: const Icon(Icons.vpn_key_sharp),
                                contentPadding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2))),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: InkWell(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    updatePassword(context);
                  }
                },
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      border: Border.all(
                        color: Colors.amber,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(40))),
                  child:  Center(
                      child: CustomText(
                    text: tr.save,
                    size: 20,
                    weight: FontWeight.bold,
                    color: Colors.white,
                  )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
