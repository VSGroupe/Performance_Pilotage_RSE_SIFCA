import 'package:flutter/material.dart';
import 'package:perf_rse/helper/helper_methods.dart';
import 'package:perf_rse/widgets/privacy_widget.dart';
import 'overview_evaluation.dart';

class ScreenOverviewEvaluation extends StatefulWidget {
  /// Constructs a [ScreenOverviewEvaluation] widget.
  const ScreenOverviewEvaluation({super.key});

  @override
  State<ScreenOverviewEvaluation> createState() => _ScreenOverviewEvaluationState();
}

class _ScreenOverviewEvaluationState extends State<ScreenOverviewEvaluation> {
  bool _isLoaded = false;
  late ScrollController _scrollController;

  void loadScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  void initState() {
    loadScreen();
    _scrollController = ScrollController();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    bool display = _isLoaded;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 16,left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
              const Text("Audit >",style: TextStyle(fontSize: 13,color: Color(0xFF3C3D3F)),),
              TextButton.icon(
                onPressed:(){},
                icon:const Icon(Icons.home),
                label: const Text("Accueil",style:TextStyle(fontWeight: FontWeight.bold,fontSize:15,color: Color(0xFF3C3D3F))),
              )
              ],
            ),
            const Text("Apercu général des audits",style: TextStyle(fontSize: 20,color: Color(0xFF3C3D3F),fontWeight: FontWeight.bold),),
            const SizedBox(height: 10,),
            display ? Expanded(child: Theme(
              data: Theme.of(context).copyWith(scrollbarTheme: ScrollbarThemeData(
                trackColor:  MaterialStateProperty.all(Colors.black12),
                trackBorderColor: MaterialStateProperty.all(Colors.black38),
                thumbColor: MaterialStateProperty.all(const Color(0xFF80868B)),
                interactive: true,
              )),
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: const Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OverviewEvaluation(),
                      SizedBox(height: 10,),
                      PrivacyWidget(),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
            )) : Expanded(
              child: Column(
                children: [
                  Expanded(child: Center(
                    child: loadingPageWidget(),//const SpinKitRipple(color: Colors.blue,),
                  )),
                  const SizedBox(height: 20,),
                  const PrivacyWidget(),
                  const SizedBox(height: 20,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}