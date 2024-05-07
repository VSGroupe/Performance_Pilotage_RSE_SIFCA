import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:perf_rse/api/supabse_db.dart';
import 'package:perf_rse/helper/helper_methods.dart';
import 'package:perf_rse/modules/styled_scrollview.dart';
import 'package:perf_rse/widgets/custom_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//import '../../../../../api/supabase.dart';
import '../../../../../helpers/helper_methods.dart';
import '../../../../../models/common/user_model.dart';
import '../../../../../models/pilotage/acces_pilotage_model.dart';
//import '../../../../../module/styled_scrollview.dart';
import '../../../../../widgets/custom_text_form_field.dart';
//import '../../../../../widgets/customtext.dart';

class PasswordPilote extends StatefulWidget {
  final UserModel userModel;
  final AccesPilotageModel accesPilotageModel;
  const PasswordPilote(
      {Key? key, required this.userModel, required this.accesPilotageModel})
      : super(key: key);

  @override
  State<PasswordPilote> createState() => _PasswordPiloteState();
}



class _PasswordPiloteState extends State<PasswordPilote> {

  late TextEditingController currentPassordTextEditingController;
  late TextEditingController newPassordTextEditingController;
  late TextEditingController checkNewPassordTextEditingController;
  final DataBaseController dbController = DataBaseController();
  final storage = FlutterSecureStorage();
  final RegExp regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
  final _formKey = GlobalKey<FormState>();
  bool containUpperCase = false;
  bool containLowerCase = false;
  bool containDigit = false;
  bool obscureTextNewPassword=false;
  bool obscureTextCheckPassword=false;
  bool obscureTextcurrentPassword=false;

  updatePassword(context) async {
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
        final result = await dbController.updatePasswordUser(
            email: email!, checkPassWord: checkPassword);
        if (result) {
          currentPassordTextEditingController.text = "";
          newPassordTextEditingController.text = "";
          checkNewPassordTextEditingController.text = "";
          ScaffoldMessenger.of(context).showSnackBar(showSnackBar(
              "Succès", "Modification éffectué avec succès", Colors.green));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              showSnackBar("Echec", "un Problème est survenue", Colors.red));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            showSnackBar("Echec", "Mots de passe différents", Colors.red));
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          showSnackBar("Echec", "Mot de Passe Incorrecte", Colors.red));
    }
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
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                    padding: const EdgeInsets.only(top:20.0,bottom: 20.0,left: 8,right: 8),
                    child:
                    Center(
                      child: Wrap(
                        spacing:5,
                        children: [
                          Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CustomText(
                                    text: "Mot de passe actuel",
                                    size: 15,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  CustomTextFormField(
                                    width: 330,
                                    obscureText:obscureTextcurrentPassword,
                                    controller: currentPassordTextEditingController,
                                    validator: (value) {
                                      if (!regex.hasMatch(value!)) {
                                        return 'Svp  votre mot de passe doit contenir 8 chiffres,\n'
                                            'des majuscules et des minuscules';
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
                                              : Icons
                                              .visibility_off),
                                        ),
                                        hintText: "Mot de passe",
                                        prefixIcon: Icon(
                                            Icons.vpn_key_sharp),
                                        contentPadding:
                                        const EdgeInsets.only(
                                            left: 20.0,
                                            right: 20.0),
                                        border:
                                        const OutlineInputBorder(),
                                        focusedBorder:
                                        OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(
                                                    context)
                                                    .primaryColor,
                                                width: 2))),
                                  ),
                                ],
                              )),

                          const SizedBox(
                            width: 10,
                          ),

                          Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: "Nouveau mot de passe",
                                    size: 15,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  CustomTextFormField(
                                    width: 330,
                                    obscureText:obscureTextNewPassword,
                                    controller: newPassordTextEditingController,
                                    validator: (value) {
                                      if (!regex.hasMatch(value!)) {
                                        return 'Svp  votre mot de passe doit contenir 8 chiffres,\n'
                                            'des majuscules et des minuscules';
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
                                              : Icons
                                              .visibility_off),
                                        ),
                                        hintText: "Mot de passe",
                                        prefixIcon: Icon(
                                            Icons.vpn_key_sharp),
                                        contentPadding:
                                        const EdgeInsets.only(
                                            left: 20.0,
                                            right: 20.0),
                                        border:
                                        const OutlineInputBorder(),
                                        focusedBorder:
                                        OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(
                                                    context)
                                                    .primaryColor,
                                                width: 2))),
                                  ),
                                ],
                              )),

                          const SizedBox(
                            width: 10,
                          ),

                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: "Vérification du mot de passe",
                                    size: 15,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  CustomTextFormField(
                                    width: 330,
                                    obscureText:obscureTextCheckPassword,
                                    controller: checkNewPassordTextEditingController,
                                    validator: (value) {
                                      if (!regex.hasMatch(value!)) {
                                        return 'Svp  votre mot de passe doit contenir 8 chiffres,\n'
                                            'des majuscules et des minuscules';
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
                                              : Icons
                                              .visibility_off),
                                        ),
                                        hintText: "Mot de passe",
                                        prefixIcon: Icon(
                                            Icons.vpn_key_sharp),
                                        contentPadding:
                                        const EdgeInsets.only(
                                            left: 20.0,
                                            right: 20.0),
                                        border:
                                        const OutlineInputBorder(),
                                        focusedBorder:
                                        OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(
                                                    context)
                                                    .primaryColor,
                                                width: 2))),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    )
                ),
              ),
            ),
            SizedBox(
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
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                  child: Center(
                      child: CustomText(
                        text: "Enregistrer",
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
