import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:perf_rse/utils/i18n.dart';
import 'package:perf_rse/utils/localization_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../helper/helper_methods.dart';
import '/widgets/custom_text.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({Key? key}) : super(key: key);

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {

  late TextEditingController _newPassWord = TextEditingController();
  late TextEditingController _confirmPassWord = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoadedPage = false;
  final RegExp spaceRegex = RegExp(r'\s');
  final supabase = Supabase.instance.client;

  bool _obscureNewPassWord = false;
  bool _obscureConfirmPassWord = false;

  String? t = "";

  void changePassWord(BuildContext context) async{
    setState(() {
      isLoadedPage = true;
    });

    try {
      String? email = supabase.auth.currentSession?.user.email;
      if (email !=null ) {
        await supabase.auth.updateUser(UserAttributes(
          email: email,
          password: _confirmPassWord.text.trim(),
        ));
        await Future.delayed(const Duration(seconds: 1));
        ScaffoldMessenger.of(context).showSnackBar(showSnackBar(tr.success, tr.passwordSuccessfullyUpdatedMessage,Colors.green));
        context.go("/account/login");
        setState(() {
          isLoadedPage = false;
        });
      }else {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          isLoadedPage = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(showSnackBar(tr.fail, tr.updatingFailMessage,Colors.red));
      }

    } catch (e) {
      final message = e.toString().split("Exception: ").join("");
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        isLoadedPage = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(showSnackBar(tr.fail,message,Colors.red));
    }

  }

  @override
  void initState() {
    super.initState();
    setState(() {
      supabase.auth.onAuthStateChange.listen((data) {
        final AuthChangeEvent event = data.event;
        final Session? session = data.session;
        t = event.name;
      });
    });

    _newPassWord = TextEditingController();
    _confirmPassWord = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final providerLocal =  Provider.of<LocalizationProvider>(context);
    return Container(
      padding: const EdgeInsets.all(10),
      width: 700,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
                        Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(Icons.language_rounded),
                          SizedBox(
                            height: 45,
                            width: 150,
                            child:  CustomDropdown(
                                hintText:tr.abrLange.toLowerCase()=="en" ? "English":"Français",
                                items:  const ["Français","English"],
                                onChanged: (value)=>providerLocal.chnageLanguage(value),
                            ),
                        )
                        ]

                        ),
          Image.asset("assets/logos/perf_rse.png",width: 300,),
          const SizedBox(height: 30,),
          CustomText(text: tr.resetPasswortTitleForm,size: 25,weight: FontWeight.bold,),
          const SizedBox(height: 20,),
          Card(
            elevation: 5,
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 480,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    autovalidateMode: AutovalidateMode.always,
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(height: 20,),
                        Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: tr.newPassword,
                                  prefixIcon: const Icon(Icons.vpn_key_sharp),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscureNewPassWord =
                                        !_obscureNewPassWord;
                                      });
                                    },
                                    child: Icon(_obscureNewPassWord
                                        ? Icons.visibility
                                        : Icons
                                        .visibility_off),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),),
                              controller: _newPassWord,
                              obscureText: _obscureNewPassWord,
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
                            const SizedBox(height: 20,),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: tr.confirmPassword,
                                  prefixIcon: const Icon(Icons.vpn_key_sharp),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscureConfirmPassWord = !_obscureConfirmPassWord;
                                      });
                                    },
                                    child: Icon(_obscureConfirmPassWord
                                        ? Icons.visibility
                                        : Icons
                                        .visibility_off),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  ),
                              controller: _confirmPassWord,
                              obscureText: _obscureConfirmPassWord,
                              validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return tr.passwordEmpty;
                                      }
                                      if (value != _newPassWord.text) {
                                        return tr.passwordNoMatch;
                                      }
                                      return null;
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 30,),
                        ElevatedButton(
                            onPressed: isLoadedPage ? null : () async {
                              if (_formKey.currentState!.validate()){
                                changePassWord(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              shape: const StadiumBorder(),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              width: double.maxFinite,
                              height: 40,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: isLoadedPage ? const SpinKitWave(color: Colors.amber, size: 20,) : CustomText(
                                text: tr.confirm,
                                color: Colors.white,
                              ),
                            )),
                        const SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40,),
          TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              onPressed: (){
                context.go("/account/login");
              }, child: Text(
            "« ${tr.goToLoginPage}",style: const TextStyle(fontSize: 22),
          ))
        ],
      ),
    );
  }
}
