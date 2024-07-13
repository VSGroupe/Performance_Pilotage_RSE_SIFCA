import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perf_rse/utils/i18n.dart';
import '/widgets/copyright.dart';
import '../../../constants/constant_colors.dart';
import '../../../widgets/custom_text.dart';

class PageNotFound extends StatefulWidget {
  const PageNotFound({super.key});

  @override
  State<PageNotFound> createState() => _PageNotFoundState();
}

class _PageNotFoundState extends State<PageNotFound> {
  bool onHoverLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60,
            color: headerApp,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 100),
                  child: Center(
                    child: Image.asset(
                      "assets/logos/perf_rse.png",
                      height: 50,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 100),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {
                            context.go('/accounts/login');
                          },
                          onHover: (value) {
                            if (value) {
                              setState(() {
                                onHoverLogin = true;
                              });
                            } else {
                              setState(() {
                                onHoverLogin = false;
                              });
                            }
                          },
                          child: CustomText(
                            text:tr.logIn,
                            color: onHoverLogin ? Colors.white : Colors.black,
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      const Icon(
                        Icons.language,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                       CustomText(
                        text:tr.abrLange,
                        color: Colors.white,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/error.png",
                width: 600,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(onPressed: (){context.go('/');}, child:  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CustomText(
                      text: tr.goToHomeRse,
                      size: 24,
                      weight: FontWeight.bold,
                    ),
                  ))
                ],
              )
            ],
          )),
          const CopyRight(),
        ],
      ),
    );
  }
}
