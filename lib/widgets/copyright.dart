import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:perf_rse/utils/i18n.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../api/supabse_db.dart';
import 'custom_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class CopyRight extends StatefulWidget {
  const CopyRight({Key? key}) : super(key: key);

  @override
  State<CopyRight> createState() => _CopyRightState();
}

class _CopyRightState extends State<CopyRight> {

  bool isConnected = true ;
  final supabase = Supabase.instance.client;

  String? version;

  Future getVersionApp() async {
    final response = await http.get(Uri.parse(DataBaseController.baseUrl));
    if (response.statusCode == 200) {
      final kVersion = jsonDecode(response.body) as Map<String, dynamic>;
      setState(() {
        version = kVersion["version"];
      });

    }

  }

  @override
  void initState() {
    getVersionApp();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF6E4906),
        border: Border.all(color: Colors.black, width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: InkWell(
              onTap: () async {
                const url = "https://visionstrategie.com/";
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
                else {
                  throw "Could not launch $url";
                }
              },
              child: CustomText(
                  text: "Copyright @ Vision & Strategie Groupe ${version??""}",
                 size: 15,
                weight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: RichText(
              text: TextSpan(
                text: "${tr.status} : ",
                children: [
                  TextSpan(
                      text: isConnected ? tr.online : tr.offline ,
                      style: TextStyle(color: isConnected ? Colors.green: Colors.red))
                ],
                style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
