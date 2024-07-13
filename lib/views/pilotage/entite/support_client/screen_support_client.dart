import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:perf_rse/api/send_mail.dart';
import 'package:perf_rse/utils/i18n.dart';
import 'package:perf_rse/modules/styled_scrollview.dart';
import 'package:perf_rse/views/pilotage/controllers/profil_pilotage_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../helper/helper_methods.dart';
import '../../../../widgets/custom_text.dart';

class ScreenSupportClient extends StatefulWidget {
  const ScreenSupportClient({super.key});

  @override
  State<ScreenSupportClient> createState() => _ScreenSupportClientState();
}

class _ScreenSupportClientState extends State<ScreenSupportClient> {
  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;
  final SendMailController sendMailController = SendMailController();
  final ProfilPilotageController profilPilotageController = Get.find();

  TextEditingController _sujetController = TextEditingController();
  TextEditingController _requestController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  File? ticketFile;

  Uint8List? selectedFileBytes;
  String? selectedFileName;
  bool? fileState;
  List pickedFiles = [];
  bool isSending = false;

  String messageFormFile = "";

  List<String> _mailsList = [];
  final List<String> _technicalSupportMails = [
    "projet.it@visionstrategie.com",
    "projet.dd@visionstrategie.com",
    "ing@visionstrategie.com"
  ];

  bool _isTechnicalSupportActive = false;

  void _toggleTechnicalSupport(bool isActive) {
    setState(() {
      _isTechnicalSupportActive = isActive;
      if (isActive) {
        for (var email in _technicalSupportMails) {
          if (!_mailsList.contains(email)) {
            _mailsList.add(email);
          }
        }
      } else {
        _mailsList
            .removeWhere((email) => _technicalSupportMails.contains(email));
      }
    });
  }

  void _addEmail(String email) {
    if (!_mailsList.contains(email)) {
      setState(() {
        _mailsList.add(email);
        _emailController.clear();
      });
    }
  }

  void _removeEmail(String email) {
    setState(() {
      _mailsList.remove(email);
    });
  }

  @override
  void initState() {
    initalisation();
    super.initState();
  }

  void initalisation() {
    _sujetController = TextEditingController();
    _requestController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 16, left: 10),
        child: Form(
          key: _formKey,
          child: StyledScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Support client",
                  style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF3C3D3F),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Card(
                  elevation: 3,
                  child: SizedBox(
                    width: 1000,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const SizedBox(height: 5,),
                        // const Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                        //   child: Text("Ouvrir un nouveau ticket",style: TextStyle(fontSize: 16,color: Color(0xFF3C3D3F),fontWeight: FontWeight.bold),),
                        // ),
                        // const SizedBox(height: 5,),
                        // const Divider(),
                        // const SizedBox(height: 5,),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Destinataire(s)",
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xFF3C3D3F)),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  const Text(
                                      "Joindre le support technique, Oui"),
                                  const SizedBox(width: 5),
                                  Checkbox(
                                    checkColor: Colors.green,
                                    value: _isTechnicalSupportActive,
                                    onChanged: (bool? value) {
                                      _toggleTechnicalSupport(value ?? false);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _emailController,
                                onFieldSubmitted: (value) {
                                  if (GetUtils.isEmail(value)) {
                                    _addEmail(value);
                                  }
                                },
                                validator: (value) {
                                  if (_mailsList.isEmpty) {
                                    return tr.occurredErrorMessage;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText:
                                      "Entrez un email et validez avec la touche 'Entrez'",
                                  contentPadding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  border: const OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  const Text("Envoyé à :"),
                                  const SizedBox(width: 30),
                                  Expanded(
                                    child: Wrap(
                                      spacing: 8.0,
                                      runSpacing: 4.0,
                                      children: _mailsList
                                          .map((email) => Chip(
                                                label: Text(email),
                                                onDeleted: () =>
                                                    _removeEmail(email),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "Sujet",
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xFF3C3D3F)),
                              ),
                              const SizedBox(height: 10),
                              sujetWidget(),
                              const SizedBox(height: 20),
                              const Text(
                                "Votre requête",
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xFF3C3D3F)),
                              ),
                              const SizedBox(height: 20),
                              requestWidget(),
                              const SizedBox(height: 20),
                              Text(
                                fileState == true
                                    ? "Fichier : $messageFormFile"
                                    : "Joindre un document",
                                style: const TextStyle(
                                    fontSize: 16, color: Color(0xFF3C3D3F)),
                              ),
                              const SizedBox(height: 10),
                              filePickerWidget(),
                              Visibility(
                                visible: fileState == false,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 5),
                                      Text(
                                        messageFormFile,
                                        style: const TextStyle(
                                            color: Color(0xFFD88292),
                                            fontSize: 15),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              buttonEnvoyer(),
                              const SizedBox(height: 20),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void sendTicket() async {
    setState(() {
      isSending = true;
    });

    final objet = _sujetController.text;
    final message = _requestController.text;

    EasyLoading.show(status: '${tr.sendingProgress} ...');
    await Future.delayed(const Duration(seconds: 1));

    try {
      final email = supabase.auth.currentUser?.email;
      final fileName = ticketFile?.path.split(Platform.pathSeparator).last;
      await supabase.from("Tickets").insert({
        "user": email,
        "objet": objet,
        "message": message,
        "file": fileName,
      });

      if (ticketFile != null && fileName != null) {
        final file = File(ticketFile!.path);
        file.writeAsBytesSync(ticketFile!.readAsBytesSync());
        await supabase.storage.from('Tickets').upload(
              'file_name.jpg',
              file.readAsBytesSync()
                  as File, // File bytes// You can specify the file type
            );
      }

      initalisation();
      setState(() {
        fileState = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          showSnackBar(tr.success, tr.succesSendMessage, Colors.green));
    } catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context)
          .showSnackBar(showSnackBar(e.toString(), "", Colors.red));
    }
    EasyLoading.dismiss();
    setState(() {
      isSending = false;
    });
    _sujetController.clear();
    _requestController.clear();
  }

  void sendSupportMail() async {
    setState(() {
      isSending = true;
    });

    EasyLoading.show(status: '${tr.sendingProgress} ...');
    await Future.delayed(const Duration(seconds: 1));

    try {
      final email = profilPilotageController.userModel.value.email;
      sendMailController.sendSupportMail(_mailsList, _sujetController.text,
          _requestController.text, email, selectedFileBytes, selectedFileName);
      // final email = supabase.auth.currentUser?.email;
      // final fileName = ticketFile?.path.split(Platform.pathSeparator).last;
      // await supabase.from("Tickets").insert({
      //   "user": email,
      //   "objet": objet,
      //   "message": message,
      //   "file": fileName,
      // });

      // if (ticketFile != null && fileName != null) {
      //   final file = File(ticketFile!.path);
      //   file.writeAsBytesSync(ticketFile!.readAsBytesSync());
      //   await supabase.storage.from('Tickets').upload(
      //         'file_name.jpg',
      //         file.readAsBytesSync()
      //             as File, // File bytes// You can specify the file type
      //       );
      // }

      // initalisation();
      // setState(() {
      //   fileState = null;
      // });
      ScaffoldMessenger.of(context).showSnackBar(
          showSnackBar(tr.success, tr.succesSendMessage, Colors.green));
    } catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context)
          .showSnackBar(showSnackBar(e.toString(), "", Colors.red));
    }
    EasyLoading.dismiss();
    setState(() {
      isSending = false;
    });
    _sujetController.clear();
    _requestController.clear();
    _emailController.clear();
  }

  Widget filePickerWidget() {
    return InkWell(
      onTap: () {
        _pickFile();
      },
      child: Container(
        height: 60,
        width: 400,
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFEAEAEA), width: 3),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(
                Icons.add_circle_outline_sharp,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                tr.downloadFile,
                style: const TextStyle(fontSize: 16, color: Color(0xFF3C3D3F)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['png', 'jpeg', 'pdf', 'jpg', 'xlsx']);

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        selectedFileBytes = result.files.single.bytes;
        selectedFileName = result.files.single.name;
        fileState = true;
        messageFormFile = "$selectedFileName";
      });
    } else {
      setState(() {
        fileState = false;
        messageFormFile = "No file selected or file data is null.";
      });
    }
  }

  Widget requestWidget() {
    return SizedBox(
      height: 150,
      child: TextFormField(
        controller: _requestController,
        maxLines: 5,
        validator: (value) {
          if (value != null && value.length < 20) {
            return tr.occurredErrorMessage;
          }
          return null;
        },
        decoration: InputDecoration(
            hintText: "",
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor, width: 2))),
      ),
    );
  }

  Widget sujetWidget() {
    return TextFormField(
      controller: _sujetController,
      validator: (value) {
        if (value != null && value.length < 10) {
          return tr.occurredErrorMessage;
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: "",
          contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 2))),
    );
  }

  Widget buttonEnvoyer() {
    return Center(
      child: InkWell(
        radius: 20,
        borderRadius: BorderRadius.circular(35),
        onTap: isSending
            ? null
            : () {
                if (_formKey.currentState!.validate() &&
                    _mailsList.isNotEmpty) {
                  //sendTicket();
                  sendSupportMail();
                }
              },
        child: Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
              color: isSending ? Colors.grey : Colors.amber,
              border: Border.all(
                color: Colors.amber,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(40))),
          child: Center(
              child: CustomText(
            text: tr.send,
            size: 20,
            weight: FontWeight.bold,
            color: Colors.white,
          )),
        ),
      ),
    );
  }
}
