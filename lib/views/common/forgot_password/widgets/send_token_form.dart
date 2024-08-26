import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:perf_rse/utils/i18n.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../helper/helper_methods.dart';
import '/widgets/custom_text.dart';

class SendTokenToEmailForm extends StatefulWidget {
  const SendTokenToEmailForm({Key? key}) : super(key: key);

  @override
  State<SendTokenToEmailForm> createState() => _SendTokenToEmailFormState();
}

class _SendTokenToEmailFormState extends State<SendTokenToEmailForm> {

  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;
  bool isLoadedPage = false;


  void sendResetCode() async{
    setState(() {
      isLoadedPage = true;
    });
    try {
      await supabase.auth.resetPasswordForEmail(_emailController.text.trim(),redirectTo: 'https://performace-rse-sifca.web.app/#/account/password-reset'); // https://performace-rse-sifca.web.app/#/account/password-reset

      setState(() {
        isLoadedPage = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(showSnackBar(tr.recoverPasswordMessage,"",Colors.blue));
      context.go("/account/login");
    } catch (e) {
      final message = e.toString().split("Exception: ").join("");
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        isLoadedPage = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(showSnackBar(message,"",Colors.red,const Duration(seconds: 8)));
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: 700,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/logos/perf_rse.png",width: 300,),
          const SizedBox(height: 30,),
          CustomText(text: tr.passwordForgetten,size: 25,weight: FontWeight.bold,),
          const SizedBox(height: 20,),
          Card(
            elevation: 10,
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: tr.email,size: 20,color: Colors.amber,),
                  const SizedBox(height: 10,),
                  CustomText(text: tr.recoverPasswordFormMessage,size: 16,),
                  Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(height: 20,),
                        Column(
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty || !GetUtils.isEmail(value)) {
                                return tr.checkEmailValueMessage;
                              }
                                  return null;
                                },
                              decoration: InputDecoration(
                                  hintText: tr.email,
                                  prefixIcon: const Icon(Icons.email),
                                  contentPadding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0),
                                  border: const OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(
                                              context)
                                              .primaryColor,
                                          width: 2))),
                              controller: _emailController,
                            ),
                          ],
                        ),
                        const SizedBox(height: 30,),
                        ElevatedButton(
                            onPressed: isLoadedPage ? null : () async {
                              if (_formKey.currentState!.validate()){
                                sendResetCode();
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
                              child: isLoadedPage ? const SpinKitWave(color: Colors.amber, size: 20,):  CustomText(
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
                "« ${tr.goToLoginPage}",style: TextStyle(fontSize: 22),
          ))
        ],
      ),
    );
  }
}
