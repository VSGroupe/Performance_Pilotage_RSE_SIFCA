import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

  TextEditingController _sujetController = TextEditingController();
  TextEditingController _requestController = TextEditingController();

  File? ticketFile;

  bool? fileState;
  bool isSending = false;

  String messageFormFile = "";

  @override
  void initState() {
    initalisation();
    super.initState();
  }
  
  
  void initalisation() {
    _sujetController = TextEditingController();
    _requestController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 16,left: 10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Support client",style: TextStyle(fontSize: 24,color: Color(0xFF3C3D3F),fontWeight: FontWeight.bold),),
              const SizedBox(height: 5,),
              Card(
                elevation: 3,
                child: SizedBox(
                  width: 1000,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5,),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                        child: Text("Ouvrir un nouveau ticket",style: TextStyle(fontSize: 16,color: Color(0xFF3C3D3F),fontWeight: FontWeight.bold),),
                      ),
                      const SizedBox(height: 5,),
                      const Divider(),
                      const SizedBox(height: 5,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Sujet",style: TextStyle(fontSize: 16,color: Color(0xFF3C3D3F)),),
                            const SizedBox(height: 10),
                            sujetWidget(),
                            const SizedBox(height: 20),
                            const Text("Votre requête",style: TextStyle(fontSize: 16,color: Color(0xFF3C3D3F)),),
                            const SizedBox(height: 20),
                            requestWidget(),
                            const SizedBox(height: 20),
                            Text( fileState == true ? "Fichier : $messageFormFile" : "Joindre un document",style: const TextStyle(fontSize: 16,color: Color(0xFF3C3D3F)),),
                            const SizedBox(height: 10),
                            filePickerWidget(),
                            Visibility(
                              visible: fileState == false,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 5),
                                    Text(messageFormFile,style: const TextStyle(color: Color(0xFFD88292),fontSize: 15),)
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
    );
  }

  void sendTicket() async {
    setState(() {
      isSending = true;
    });

    final objet = _sujetController.text;
    final message = _requestController.text;

    EasyLoading.show(status: 'Envoi en cours ...');
    await Future.delayed(const Duration(seconds: 1));

    try {
      final email = supabase.auth.currentUser?.email;
      final fileName = ticketFile?.path.split(Platform.pathSeparator).last;
      await supabase.from("Tickets").insert(
          {
            "user":email,
            "objet": objet,
            "message" : message,
            "file":fileName,
          }
      );

       if (ticketFile != null && fileName != null ) {
         final file = File(ticketFile!.path);
         file.writeAsBytesSync(ticketFile!.readAsBytesSync());
         await supabase.storage.from('Tickets').upload(
           'file_name.jpg',
           file.readAsBytesSync() as File, // File bytes// You can specify the file type
         );
       }

      initalisation();
      setState(() {
        fileState = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(showSnackBar("Succès", "Votre réquête a été envoyé avec succès." , Colors.green));
    }catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(showSnackBar(e.toString(), "", Colors.red));
    }
    EasyLoading.dismiss();
    setState(() {
      isSending = false;
    });
    _sujetController.clear();
    _requestController.clear();
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
            border: Border.all(color: const Color(0xFFEAEAEA),width: 3),
            borderRadius: BorderRadius.circular(10)
        ),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(Icons.add_circle_outline_sharp,color: Colors.grey,),
              SizedBox(width: 10,),
              Text("Cliquer ici pour télécharger un fichier.",style: TextStyle(fontSize: 16,color: Color(0xFF3C3D3F)),),
            ],
          ),
        ),
      ),
    );
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );
    
    if (result != null) {
      String filePath = result.files.single.path!;
      final file = File(filePath);
      if (file.lengthSync() <= 512000) {
        final name = filePath.split(Platform.pathSeparator).last;
        file.rename(name);
        setState(() {
          fileState = true;
          messageFormFile = "${filePath}";
          ticketFile = file;
        });
      } else {
        setState(() {
          fileState = false;
          messageFormFile = "La taille du fichier dépasse la limite de 500 Ko.";
        });
      }
    }
  }

  Widget requestWidget() {
    return SizedBox(
      height: 150,
      child: TextFormField(
        controller: _requestController,
        maxLines: 5,
        validator: (value) {
          if (value !=null && value.length < 20 ) {
            return "Une erreur est survenue.";
          }
          return null;
        },
        decoration: InputDecoration(
            hintText: "",
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2
                )
            )
        ),
      ),
    );
  }

  Widget sujetWidget() {
    return TextFormField(
      controller: _sujetController,
      validator: (value) {
        if (value!=null && value.length < 10 ) {
          return "Une erreur est survenue.";
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: "",
          contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2
              )
          )
      ),
    );
  }

  Widget buttonEnvoyer () {
    return  Center(
      child: InkWell(
        radius: 20,
        borderRadius: BorderRadius.circular(35),
        onTap: isSending ? null : () {
          if (_formKey.currentState!.validate()) {
            sendTicket();
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
          child: const Center(
              child: CustomText(
                text: "Envoyer",
                size: 20,
                weight: FontWeight.bold,
                color: Colors.white,
              )),
        ),
      ),
    );
  }
  
}
