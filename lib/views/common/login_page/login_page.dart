import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:perf_rse/utils/i18n.dart';
import 'package:perf_rse/utils/localization_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../constants/constant_colors.dart';
import '../../../helper/helper_methods.dart';
import '../../../utils/utils.dart';
import '../../../widgets/export_widget.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final storage = const FlutterSecureStorage();

  final _formKey = GlobalKey<FormState>();
  final _formKeyFirstConnexion = GlobalKey<FormState>();
  bool _obsureText = true;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final nom;
  late final prenoms;

  final RegExp regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');

  final supabase = Supabase.instance.client;

  bool isLoadedPage = false;

  String? session = "B";
  Session? sessionUser;

  bool isHovering = false;

  bool onLogging = false;
  bool isLogging = false;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future trackUserLogin(String email) async {
    try {
      final ipAddress = await Ipify.ipv4();
      final localisation = await getCountryCityFromIP(ipAddress);

      await supabase.from('Historiques').insert({
        'action': 'Connexion',
        'user': email,
        "ip": ipAddress,
        "localisation": localisation
      });
    } catch (e) {
      return;
    }
  }

  Future<void>hanldeLangue(String email,BuildContext context) async {
       final List responseName =   await supabase.from('Users').select('langue').eq('email', email);
       if (responseName.first["langue"] == "fr") {
          Provider.of<LocalizationProvider>(context).chnageLanguage('Francais');
        } else {
           Provider.of<LocalizationProvider>(context).chnageLanguage('English');
        }
  }

  Future<bool> checkName(String email) async {
    final List responseName =
        await supabase.from('Users').select('nom').eq('email', email);
    if (responseName.first["nom"] == "Nouvel") {
      return false;
    } else {
      return true;
    }
  }

  void login(BuildContext context) async {
    setState(() {
      isLoadedPage = true;
    });
    try {
      final result = await supabase.auth.signInWithPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final email = result.user?.email;
      final accesToken = result.session?.accessToken;

      if (email != null && accesToken != null) {
       
        final date = DateTime.now();
        await storage.write(key: 'expiration', value: date.toString());
        await storage.write(key: 'logged', value: "true");
        await storage.write(key: 'email', value: email);
        //await  hanldeLangue(email, context);
        await trackUserLogin(email);
        bool userCheckName = await checkName(email);
        if (userCheckName == false) {
          // ignore: use_build_context_synchronously
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title:  Text(tr.newUserFormTitle),
                  content: Form(
                    key: _formKeyFirstConnexion,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "${tr.checkNameValue}.";
                            }
                            nom = value;
                            return null;
                          },
                          decoration:  InputDecoration(
                            border: const UnderlineInputBorder(),
                            labelText:tr.nameField,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return tr.checkForenameValue;
                            }
                            prenoms = value;
                            return null;
                          },
                          decoration:  InputDecoration(
                              border: const UnderlineInputBorder(),
                              labelText: tr.forenameField),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKeyFirstConnexion.currentState!
                                  .validate()) {
                                await supabase
                                    .from('Users')
                                    .update({'nom': nom, 'prenom': prenoms}).eq(
                                        'email', email);
                                await Future.delayed(
                                    const Duration(milliseconds: 100));
                                context.go("/");
                              }
                            },
                            child:  Text(tr.confirm),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        } else {
          await Future.delayed(const Duration(milliseconds: 100));
          context.go("/");
          setState(() {
            isLoadedPage = false;
          });
        }
      } else {
        var message = tr.incorrectLoginDetailsMessage;
        await Future.delayed(const Duration(milliseconds: 15));
        setState(() {
          isLoadedPage = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(showSnackBar(tr.fail, message, Colors.red));
      }
    } on Exception {
      var message = tr.incorrectLoginDetailsMessage;
      await Future.delayed(const Duration(milliseconds: 15));
      setState(() {
        isLoadedPage = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(showSnackBar(tr.fail, message, Colors.red));
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      setState(() {
        session = event.name;
      });
      print(event.name);
      if (session == "passwordRecovery") {
        context.go("/account/change-password", extra: "passowrdRecovery");
      }
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerLocal =  Provider.of<LocalizationProvider>(context);
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
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 150,
                      width: 300,
                      child: Image.asset(
                        "assets/logos/perf_rse.png",
                        height: 150,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Image.network(
                      "https://djlcnowdwysqbrggekme.supabase.co/storage/v1/object/public/Images/image_accueil.png",
                      height: 350,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RichText(
                      text:  TextSpan(
                          text: "",
                          style: const TextStyle(
                              fontSize: 30,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6E4906)),
                          children: <TextSpan>[
                            const TextSpan(
                                text: "Performance ",
                                style: TextStyle(color: Color(0xFF2A9836))),
                            TextSpan(
                                text:tr.rse,
                                style: TextStyle(color: Color(0xFF0F70B7))),
                            TextSpan(text:tr.slogan),
                          ]),
                    )
                  ],
                )),
                Expanded(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.language_rounded),
                          SizedBox(
                            height: 60,
                            width: 150,
                            child:  Container(
                              child: CustomDropdown(
                                  hintText:tr.abrLange.toLowerCase()=="en" ? "English":"Français",
                                  items:  ["Français","English"],
                                  onChanged: (value)=>providerLocal.chnageLanguage(value),
                              ),
                          ),
                        )
                        ]

                        ),
                        SizedBox(
                          height: 150,
                          width: 300,
                          child: Image.asset(
                            "assets/logos/logo_sifca_bon.png",
                            height: 150,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 400,
                          height: 450,
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Form(
                                autovalidateMode: AutovalidateMode.disabled,
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(tr.conexionMessage ,
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF9D6E16)),
                                    ),
                                    Column(
                                      children: [
                                        TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty ||
                                                !GetUtils.isEmail(value)) {
                                              return tr.checkEmailValueMessage;
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              hintText:tr.email,
                                              prefixIcon:
                                                  const Icon(Icons.person),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 20.0, right: 20.0),
                                              border:
                                                  const OutlineInputBorder(),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      width: 2))),
                                          controller: _emailController,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          obscureText: _obsureText,
                                          controller: _passwordController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return tr.passwordCheckMessage;
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _obsureText = !_obsureText;
                                                  });
                                                },
                                                child: Icon(_obsureText
                                                    ? Icons.visibility
                                                    : Icons.visibility_off),
                                              ),
                                              hintText:tr.password,
                                              prefixIcon: const Icon(
                                                  Icons.vpn_key_sharp),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 20.0, right: 20.0),
                                              border:
                                                  const OutlineInputBorder(),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      width: 2))),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onHover: (value) {
                                        setState(() {
                                          isHovering = value;
                                        });
                                      },
                                      onTap: () {},
                                      child: ElevatedButton(
                                          onPressed: isLoadedPage
                                              ? null
                                              : () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    login(context);
                                                  }
                                                },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.amber,
                                            side: const BorderSide(
                                                width: 1, color: Colors.black),
                                            shape: isHovering
                                                ? const StadiumBorder()
                                                : RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                          ),
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: double.maxFinite,
                                            height: 50,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: isLoadedPage
                                                ? const SpinKitWave(
                                                    color: Colors.amber,
                                                    size: 20,
                                                  )
                                                :  CustomText(
                                                    text: tr.logIn,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          context
                                              .go('/account/forgot-password');
                                        },
                                        child:  CustomText(
                                          text: tr.passwordForgetten,
                                          color: activeBlue,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        const CopyRight()
      ],
    ));
  }
}
