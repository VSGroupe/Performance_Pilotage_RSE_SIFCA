import 'package:flutter/material.dart';
import 'package:perf_rse/views/common/forgot_password/widgets/change_password_form.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChangePassWordScreen extends StatefulWidget {

  const ChangePassWordScreen({super.key});

  @override
  State<ChangePassWordScreen> createState() => _ChangePassWordScreenState();
}

class _ChangePassWordScreenState extends State<ChangePassWordScreen> {

  var onHoverLogin = false;
  final supabase = Supabase.instance.client;
  
  @override
  void initState() {
    super.initState();
    // if (widget.event != "passwordRecovery"){
    //   context.go("/account/login");
    // }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: const Color(0xFFF4F4F4),
        child: Column(
          children: [
            Expanded(
                child: Row(
                  children: [
                    if(width > 1100) Expanded(child: Container(
                      height: double.infinity,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFFBCD18),
                              Color(0xFFFABC29),
                              Color(0xFFFBCD18),
                              Color(0xFFFBCD18),
                            ],
                          )
                      ),
                      child: Image.asset("assets/images/password_change.png",fit: BoxFit.contain,width: width,),
                    )),
                    Expanded(child: Center(child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(20),
                      child: const ChangePasswordForm(),
                    ),
                    ))
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}


