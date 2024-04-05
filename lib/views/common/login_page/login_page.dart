import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../constants/constant_colors.dart';
import '../../../helper/helper_methods.dart';
import '../../../utils/utils.dart';
import '../../../widgets/export_widget.dart';

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

  // Future<int> countConnexion(String email) async {
  //   final List responseConnexion = await supabase
  //       .from('Historiques')
  //       .select('action')
  //       .eq('action', "Connexion")
  //       .eq('user', email);
  //   final int result = responseConnexion.length;
  //   if (responseConnexion.isEmpty) {
  //     return 0;
  //   } else {
  //     return result;
  //   }
  // }

  Future<bool> checkName(String email) async {
    final List responseName =
        await supabase.from('Users').select('nom').eq('email', email);
    print(responseName.first["nom"]);
    if (responseName.first["nom"] == "") {
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
        await trackUserLogin(email);
        bool userCheckName = await checkName(email);
        if (userCheckName == false) {
          // ignore: use_build_context_synchronously
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text("Nouvel Utilisateur"),
                    content: Form(
                      key: _formKeyFirstConnexion,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez votre nom svp.';
                              }
                              nom = value;
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Entrez votre nom',
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer vos premons svp.';
                              }
                              prenoms = value;
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Entrez vos prenoms',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKeyFirstConnexion.currentState!
                                    .validate()) {
                                  await supabase.from('Users').update({
                                    'nom': nom,
                                    'prenom': prenoms
                                  }).eq('email', email);
                                  await Future.delayed(
                                      const Duration(milliseconds: 100));
                                  context.go("/");
                                }
                              },
                              child: const Text('Valider'),
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
        const message = "Vos identifiants sont incorrectes";
        await Future.delayed(const Duration(milliseconds: 15));
        setState(() {
          isLoadedPage = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(showSnackBar("Echec", message, Colors.red));
      }
    } on Exception {
      const message = "Vos identifiants sont incorrects";
      await Future.delayed(const Duration(milliseconds: 15));
      setState(() {
        isLoadedPage = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(showSnackBar("Echec", message, Colors.red));
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
    double height = MediaQuery.of(context).size.height.roundToDouble();
    double width = MediaQuery.of(context).size.width.roundToDouble();
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
                      text: const TextSpan(
                          text: "",
                          style: TextStyle(
                              fontSize: 30,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6E4906)),
                          children: <TextSpan>[
                            TextSpan(
                                text: "Performance ",
                                style: TextStyle(color: Color(0xFF2A9836))),
                            TextSpan(
                                text: "RSE",
                                style: TextStyle(color: Color(0xFF0F70B7))),
                            TextSpan(
                                text:
                                    ", pilotez votre stratégie de développement durable en toute simplicité. "),
                          ]),
                    )
                  ],
                )),
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
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
                                    const Text(
                                      "Se connecter à votre compte",
                                      style: TextStyle(
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
                                              return 'Svp veuillez entrer un e-mail correct.';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              hintText: "Courriel",
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
                                                value.isEmpty ||
                                                value.length < 8) {
                                              return 'Le mot de passe doit avoir au moins de 8 caractères.';
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
                                              hintText: "Mot de passe",
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
                                                : const CustomText(
                                                    text: "Se connecter",
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
                                        child: const CustomText(
                                          text: "J’ai oublié mon mot de passe",
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
