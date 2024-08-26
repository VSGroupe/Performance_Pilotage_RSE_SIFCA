import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perf_rse/helper/helper_methods.dart';
import 'package:perf_rse/utils/i18n.dart';
import 'package:perf_rse/utils/localization_provider.dart';
import 'package:perf_rse/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  final RegExp spaceRegex = RegExp(r'\s');
  bool obscureTextNewPassword = false;
  bool obscureTextCheckPassword = false;
  bool isLoadedPage = false;
  late TextEditingController _passwordController = TextEditingController();
  late TextEditingController _confirmPasswordController =
      TextEditingController();

  void resetPassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      print("Password: ${_passwordController.text}");
      print("Confirm Password: ${_confirmPasswordController.text}");

      setState(() {
        isLoadedPage = true;
      });

      try {
        String? email = supabase.auth.currentSession?.user.email;
        if (email != null) {
          await supabase.auth.updateUser(UserAttributes(
            email: email,
            password: _passwordController.text,
          ));
        await Future.delayed(const Duration(seconds: 1));
        ScaffoldMessenger.of(context).showSnackBar(showSnackBar(
            tr.success, tr.passwordSuccessfullyUpdatedMessage, Colors.green));
        context.go("/account/login");
        } else {
        setState(() {
          isLoadedPage = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(showSnackBar(tr.fail, tr.updatingFailMessage,Colors.red));         
        }
      } catch (e) {
        final message = e.toString().split("Exception: ").join("");
        await Future.delayed(const Duration(seconds: 1));
        ScaffoldMessenger.of(context)
            .showSnackBar(showSnackBar(tr.fail, message, Colors.red));
      }
    }
  }


  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final providerLocal = Provider.of<LocalizationProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/images/fond_accueil.jpg",
                      ),
                      fit: BoxFit.fill)),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 200,
                        child: Image.asset(
                          "assets/logos/logo_sifca_bon.png",
                          height: 50,
                        ),
                      )
                    ],
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    const Icon(Icons.language_rounded),
                    SizedBox(
                      height: 45,
                      width: 150,
                      child: CustomDropdown(
                        hintText: tr.abrLange.toLowerCase() == "en"
                            ? "English"
                            : "Français",
                        items: const ["Français", "English"],
                        onChanged: (value) =>
                            providerLocal.chnageLanguage(value),
                      ),
                    )
                  ]),
                  SizedBox(
                    height: 150,
                    width: 300,
                    child: Image.asset(
                      "assets/logos/perf_rse.png",
                      height: 150,
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: 400,
                        child: Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        tr.resetPasswortTitleForm,
                                        style: const TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20.0),
                                  CustomTextFormField(
                                    controller: _passwordController,
                                    obscureText: obscureTextNewPassword,
                                    decoration: InputDecoration(
                                      labelText: tr.newPassword,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      prefixIcon:
                                          const Icon(Icons.vpn_key_sharp),
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
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return tr.passwordEmpty;
                                      }
                                      if (value.length < 6) {
                                        return tr.passwordLengthMessage;
                                      }
                                      if (spaceRegex.hasMatch(value)) {
                                        return tr.passwordMustNotContainSpace;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20.0),
                                  CustomTextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: obscureTextCheckPassword,
                                    decoration: InputDecoration(
                                      labelText: tr.confirmPassword,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      prefixIcon:
                                          const Icon(Icons.vpn_key_sharp),
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
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return tr.passwordEmpty;
                                      }
                                      if (value != _passwordController.text) {
                                        return tr.passwordNoMatch;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20.0),
                                  ElevatedButton(
                                    onPressed: isLoadedPage ? null : 
                                    () async {
                                      resetPassword(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 24.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    child: Text(
                                      tr.confirm,
                                      style: const TextStyle(fontSize: 18.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
