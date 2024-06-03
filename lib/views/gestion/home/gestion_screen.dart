import 'package:flutter/material.dart';
import 'package:perf_rse/modules/styled_scrollview.dart';
import 'package:perf_rse/views/common/main_page/widget/banniere.dart';
import 'package:perf_rse/views/gestion/home/widgets/content_grid.dart';

class GestionScreen extends StatelessWidget {
  const GestionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des outils et ressources'),
        centerTitle: false, // Définir centerTitle sur false
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5.0),
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background_image.jpg"),
                  fit: BoxFit.fitWidth)
              ),
              child: StyledScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                                                                Image.asset(
                                    "assets/logos/perf_rse.png",
                                    height: 50,
                                  ),
                            ],
                          ),
                                                  const SizedBox(
                                height: 10,
                              ),
                              const Center(child: Banniere()),
                              const SizedBox(
                                height: 10,
                              ),
                        const SizedBox(
                          width: 1200,
                          child: ContentGrid()),
                        ],
                        //ContentGrid(),
                      ),
                    ]
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


